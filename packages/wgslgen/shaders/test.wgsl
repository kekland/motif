// 1. EXTENSIONS
enable f16; // Forces your generator to handle half-precision types!

// 2. PIPELINE OVERRIDES (Constants)
@id(0) override workgroup_size_x: u32 = 64;
@id(1) override use_shadows: bool = true;
override global_bias: f32 = 0.0015;

// 3. STRUCTS WITH ALIGNMENT TRAPS
struct GlobalConfig {
    time: f32,
    delta_time: f32,
    frame_count: u32,
    // Trap 1: Arrays in uniforms MUST have 16-byte stride. vec4u satisfies this.
    resolutions: array<vec4u, 4>, 
}

struct TransformData {
    model: mat4x4f,
    view: mat4x4f,
    // Trap 2: mat3x3f takes 48 bytes (three 16-byte columns), NOT 36 bytes!
    normal_mat: mat3x3f, 
}

struct Material {
    albedo: vec4f,
    roughness: f32,
    metallic: f32,
    // Trap 3: Half-precision vectors in storage buffers
    emission: vec3<f16>, 
}

struct Particle {
    pos: vec3f, // 12 bytes, but aligns to 16!
    vel: vec3f,
    age: f32,
}

struct Counters {
    // Trap 4: Atomics
    alive_count: atomic<u32>,
    dead_count: atomic<i32>,
}

// ==========================================
// GROUP 0: GLOBAL FRAME DATA (Mixed Textures)
// ==========================================
@group(0) @binding(0) var<uniform> u_config: GlobalConfig;
@group(0) @binding(1) var t_env_map: texture_cube<f32>;
@group(0) @binding(2) var s_linear: sampler;
@group(0) @binding(3) var t_shadow_map: texture_depth_2d;
@group(0) @binding(4) var s_shadow_cmp: sampler_comparison; // Comparison sampler!
@group(0) @binding(5) var t_multisampled: texture_multisampled_2d<f32>;

// ==========================================
// GROUP 1: OBJECT DATA (Skipped bindings)
// ==========================================
@group(1) @binding(0) var<uniform> u_transform: TransformData;
@group(1) @binding(1) var<storage, read> b_materials: array<Material>;
@group(1) @binding(2) var t_albedo: texture_2d<f32>;
// Notice we skipped binding 3! Your groups map should handle sparse indices.
@group(1) @binding(4) var t_data_1d: texture_1d<u32>; // Uint texture!
@group(1) @binding(5) var<uniform> u_float: f32;
@group(1) @binding(6) var<uniform> u_vec3: vec3f;
@group(1) @binding(7) var<uniform> u_arr: array<mat4x4f, 4>;
@group(1) @binding(8) var<uniform> u_arr_mat: array<Material, 4>;

// ==========================================
// GROUP 2: COMPUTE & STORAGE TEXTURES
// ==========================================
@group(2) @binding(0) var<storage, read_write> b_particles: array<Particle>;
@group(2) @binding(1) var<storage, read_write> b_counters: Counters;
// Trap 5: Storage textures with explicit formats
@group(2) @binding(2) var t_voxel_grid: texture_storage_3d<rgba8unorm, write>;
@group(2) @binding(3) var t_output_image: texture_storage_2d<rgba16float, write>;


// ==========================================
// ENTRY 1: VERTEX SHADER
// ==========================================
struct VertexInput {
    @location(0) position: vec3f,
    @location(1) uv: vec2f,
    @location(2) normal: vec3f,
    @location(3) custom_data: vec4i,
}

struct VertexOutput {
    @builtin(position) clip_pos: vec4f,
    @location(0) uv: vec2f,
    @location(1) world_normal: vec3f,
}

@vertex
fn vs_main(in: VertexInput) -> VertexOutput {
    var out: VertexOutput;
    out.clip_pos = u_transform.model * vec4f(in.position, 1.0);
    out.uv = in.uv;
    out.world_normal = u_transform.normal_mat * in.normal;
    return out;
}

// ==========================================
// ENTRY 2: FRAGMENT SHADER
// ==========================================
@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4f {
    let base_color = textureSample(t_albedo, s_linear, in.uv);
    let shadow = textureSampleCompare(t_shadow_map, s_shadow_cmp, in.uv, 0.5);
    
    if (use_shadows) {
        return base_color * shadow;
    }
    return base_color + global_bias;
}

// ==========================================
// ENTRY 3: COMPUTE SHADER
// ==========================================
@compute @workgroup_size(workgroup_size_x, 1, 1)
fn cs_main(@builtin(global_invocation_id) id: vec3u) {
    let index = id.x;
    
    // Read/Write storage array
    var p = b_particles[index];
    p.age += u_config.delta_time;
    b_particles[index] = p;

    // Atomic usage
    if (p.age > 10.0) {
        atomicAdd(&b_counters.dead_count, 1);
    } else {
        atomicAdd(&b_counters.alive_count, 1u);
    }

    // Write to storage texture
    let write_coord = vec2i(i32(id.x), i32(id.y));
    textureStore(t_output_image, write_coord, vec4f(1.0, 0.0, 0.0, 1.0));
}