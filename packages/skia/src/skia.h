#ifndef SKIA_H
#define SKIA_H

#include "exports.h"
#include "stddef.h"
#include "stdint.h"

// ---------------------------------------------------------------------------------------------------------------------
// font_provider
// ---------------------------------------------------------------------------------------------------------------------

typedef struct font_provider* font_provider_t;

FFI font_provider_t motif_font_provider_create();
FFI void motif_font_provider_destroy(font_provider_t provider);

FFI int32_t motif_font_provider_add(font_provider_t provider, const uint8_t* data, size_t length, int32_t index,
                                    const char* family);

FFI int32_t motif_font_provider_family_count(const font_provider_t provider);
FFI size_t motif_font_provider_family_name(const font_provider_t provider, int32_t index, char* buffer);

// ---------------------------------------------------------------------------------------------------------------------
// paragraph_style
// ---------------------------------------------------------------------------------------------------------------------

typedef struct paragraph_style* paragraph_style_t;

FFI paragraph_style_t motif_paragraph_style_create();
FFI void motif_paragraph_style_destroy(paragraph_style_t style);

// ---------------------------------------------------------------------------------------------------------------------
// text_style
// ---------------------------------------------------------------------------------------------------------------------

typedef struct text_style* text_style_t;

FFI text_style_t motif_text_style_create();
FFI void motif_text_style_destroy(text_style_t style);

FFI double motif_text_style_get_font_size(text_style_t style);
FFI void motif_text_style_set_font_size(text_style_t style, double size);

FFI size_t motif_text_style_get_font_families_count(text_style_t style);
FFI size_t motif_text_style_get_font_family(text_style_t style, int32_t index, char* buffer);
FFI void motif_text_style_set_font_families(text_style_t style, const char** families, int count);

// ---------------------------------------------------------------------------------------------------------------------
// paragraph
// ---------------------------------------------------------------------------------------------------------------------

typedef struct paragraph* paragraph_t;

typedef struct {
  float left, baseline, ascent, descent, width, height;
  uint32_t glyph_start, glyph_end;
} line_metrics;

typedef struct {
  float x, y;
  float left, top, right, bottom;
  uint16_t id, font;
} glyph_metrics;

typedef struct {
  uint32_t verb_count, point_count;
  const uint8_t* verbs;
  const float* points;
} glyph_path;

FFI void motif_paragraph_destroy(paragraph_t p);

FFI void motif_paragraph_layout(paragraph_t p, double width);
FFI double motif_paragraph_get_height(paragraph_t p);
FFI double motif_paragraph_get_longest_line(paragraph_t p);
FFI double motif_paragraph_get_max_intrinsic_width(paragraph_t p);
FFI double motif_paragraph_get_min_intrinsic_width(paragraph_t p);

FFI size_t motif_paragraph_get_line_metrics_count(paragraph_t p);
FFI const line_metrics* motif_paragraph_get_line_metrics(paragraph_t p);
FFI size_t motif_paragraph_get_glyph_metrics_count(paragraph_t p);
FFI const glyph_metrics* motif_paragraph_get_glyph_metrics(paragraph_t p);
FFI const glyph_path* motif_paragraph_get_glyph_path(paragraph_t p, size_t index);

// ---------------------------------------------------------------------------------------------------------------------
// paragraph_builder
// ---------------------------------------------------------------------------------------------------------------------

typedef struct paragraph_builder* paragraph_builder_t;

FFI paragraph_builder_t motif_paragraph_builder_create(paragraph_style_t style, font_provider_t provider);
FFI void motif_paragraph_builder_destroy(paragraph_builder_t builder);

FFI void motif_paragraph_builder_add_text(paragraph_builder_t builder, const char* text);
FFI void motif_paragraph_builder_push_style(paragraph_builder_t builder, text_style_t style);
FFI void motif_paragraph_builder_pop_style(paragraph_builder_t builder);
FFI paragraph_t motif_paragraph_builder_build(paragraph_builder_t builder);

#endif  // SKIA_H