struct Decoration {
  kind: u32,
  v0: f32,
  v1: f32,
  v2: f32,
  v3: f32,
}

const DECORATION_NONE = Decoration(
  DECORATION_KIND_NONE,
  0.0, 0.0, 0.0, 0.0
);

const DECORATION_KIND_NONE = 0;
const DECORATION_KIND_COLOR = 1;
const DECORATION_KIND_IMAGE = 2;
const DECORATION_KIND_FRAGMENT_SHADER = 3;
