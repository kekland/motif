#ifndef SKIA_H
#define SKIA_H

#include "exports.h"
#include "stdbool.h"
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

typedef enum {
  TEXT_ALIGNMENT_LEFT,
  TEXT_ALIGNMENT_RIGHT,
  TEXT_ALIGNMENT_CENTER,
  TEXT_ALIGNMENT_JUSTIFY,
  TEXT_ALIGNMENT_START,
  TEXT_ALIGNMENT_END
} text_alignment;

FFI paragraph_style_t motif_paragraph_style_create();
FFI void motif_paragraph_style_destroy(paragraph_style_t style);

FFI void motif_paragraph_style_set_apply_rounding_hack(paragraph_style_t style, bool apply);

FFI void motif_paragraph_style_set_alignment(paragraph_style_t style, text_alignment alignment);
FFI text_alignment motif_paragraph_style_get_alignment(paragraph_style_t style);

FFI void motif_paragraph_style_set_ellipsis(paragraph_style_t style, const char* ellipsis);
FFI size_t motif_paragraph_style_get_ellipsis(paragraph_style_t style, char* buffer);

// ---------------------------------------------------------------------------------------------------------------------
// text_style
// ---------------------------------------------------------------------------------------------------------------------

typedef struct text_style* text_style_t;

typedef enum {
  TEXT_STYLE_FONT_STYLE_SLANT_UPRIGHT,
  TEXT_STYLE_FONT_STYLE_SLANT_ITALIC,
  TEXT_STYLE_FONT_STYLE_SLANT_OBLIQUE,
} text_style_font_style_slant;

typedef struct {
  int32_t weight;
  int32_t width;
  text_style_font_style_slant slant;
} text_style_font_style;

FFI text_style_t motif_text_style_create();
FFI void motif_text_style_destroy(text_style_t style);

FFI size_t motif_text_style_get_font_families_count(text_style_t style);
FFI size_t motif_text_style_get_font_family(text_style_t style, int32_t index, char* buffer);
FFI void motif_text_style_set_font_families(text_style_t style, const char** families, int count);

FFI double motif_text_style_get_font_size(text_style_t style);
FFI void motif_text_style_set_font_size(text_style_t style, double size);

FFI double motif_text_style_get_height(text_style_t style);
FFI void motif_text_style_set_height(text_style_t style, double height);

FFI double motif_text_style_get_letter_spacing(text_style_t style);
FFI void motif_text_style_set_letter_spacing(text_style_t style, double letter_spacing);

FFI text_style_font_style motif_text_style_get_font_style(text_style_t style);
FFI void motif_text_style_set_font_style(text_style_t style, text_style_font_style font_style);

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

// ---------------------------------------------------------------------------------------------------------------------
// font_file
// ---------------------------------------------------------------------------------------------------------------------

typedef struct font_file* font_file_t;

typedef struct {
  int32_t index;
  int32_t weight;
  int32_t width;
  text_style_font_style_slant slant;
  const char* family;
} font_face;

FFI font_file_t motif_font_file_create(const uint8_t* data, size_t length);
FFI void motif_font_file_destroy(font_file_t file);

FFI int32_t motif_font_file_face_count(font_file_t file);
FFI void motif_font_file_get_face(font_file_t file, int32_t index, font_face* face);

#endif  // SKIA_H