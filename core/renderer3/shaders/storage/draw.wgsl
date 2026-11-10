#import "../_bindings.wgsl"

struct DrawEntry {
  cell: u32,
  kind: u32,
  decoration_span: vec2u,
}

const DRAW_ENTRY_KIND_VERTEX = 1u;
const DRAW_ENTRY_KIND_EDGE = 2u;
const DRAW_ENTRY_KIND_FACE_FAN = 3u;
const DRAW_ENTRY_KIND_FACE_COVER = 4u;
const DRAW_ENTRY_KIND_GLYPH_EDGE = 5u;
const DRAW_ENTRY_KIND_GLYPH_FACE_FAN = 6u;
const DRAW_ENTRY_KIND_GLYPH_FACE_COVER = 7u;

fn read_draw_entry(index: u32) -> DrawEntry {
  let offset = storage_offsets.draw_entry + index * 4u;
  return DrawEntry(
    bitcast<u32>(draw[offset + 0u]),
    bitcast<u32>(draw[offset + 1u]),
    vec2u(bitcast<u32>(draw[offset + 2u]), bitcast<u32>(draw[offset + 3u]))
  );
}

fn read_draw_edge(index: u32) -> u32 {
  let offset = storage_offsets.draw_edge + index;
  return bitcast<u32>(draw[offset]);
}

fn read_draw_order(index: u32) -> u32 {
  let offset = storage_offsets.draw_order + index;
  return bitcast<u32>(draw[offset]);
}
