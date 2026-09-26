#include "skia.h"

#include <core/SkData.h>
#include <core/SkFontMgr.h>
#include <core/SkTypeface.h>
#include <modules/skparagraph/include/FontCollection.h>
#include <modules/skparagraph/include/ParagraphBuilder.h>
#include <modules/skparagraph/include/ParagraphStyle.h>
#include <modules/skparagraph/include/TextStyle.h>
#include <modules/skparagraph/include/TypefaceFontProvider.h>
#include <ports/SkFontMgr_empty.h>

using namespace skia::textlayout;

// ---------------------------------------------------------------------------------------------------------------------
// font_provider
// ---------------------------------------------------------------------------------------------------------------------

struct font_provider {
  sk_sp<TypefaceFontProvider> value = sk_make_sp<TypefaceFontProvider>();
  sk_sp<FontCollection> collection = sk_make_sp<FontCollection>();
};

SkFontMgr* sk_font_mgr() {
  static const sk_sp<SkFontMgr> mgr = SkFontMgr_New_Custom_Empty();
  return mgr.get();
}

FFI font_provider_t motif_font_provider_create() {
  font_provider_t provider = new font_provider();
  provider->collection->setAssetFontManager(provider->value);
  provider->collection->disableFontFallback();
  return provider;
}

FFI void motif_font_provider_destroy(font_provider_t provider) { delete provider; }

FFI int32_t motif_font_provider_add(font_provider_t provider, const uint8_t* data, size_t length, int32_t index,
                                    const char* family) {
  auto typeface = sk_font_mgr()->makeFromData(SkData::MakeWithCopy(data, length), index);
  if (!typeface) return 0;

  const size_t registered = family && *family ? provider->value->registerTypeface(std::move(typeface), SkString(family))
                                              : provider->value->registerTypeface(std::move(typeface));

  return registered > 0 ? 1 : 0;
}

FFI int32_t motif_font_provider_family_count(font_provider_t provider) {
  return static_cast<int32_t>(provider->value->countFamilies());
}

FFI size_t motif_font_provider_family_name(font_provider_t provider, int32_t index, char* buffer) {
  SkString name;
  provider->value->getFamilyName(index, &name);
  if (buffer) {
    strncpy(buffer, name.c_str(), name.size() + 1);
  }
  return name.size();
}

// ---------------------------------------------------------------------------------------------------------------------
// paragraph_style
// ---------------------------------------------------------------------------------------------------------------------

struct paragraph_style {
  ParagraphStyle value;
};

FFI paragraph_style_t motif_paragraph_style_create() { return new paragraph_style(); }
FFI void motif_paragraph_style_destroy(paragraph_style_t style) { delete style; }

// ---------------------------------------------------------------------------------------------------------------------
// text_style
// ---------------------------------------------------------------------------------------------------------------------

struct text_style {
  TextStyle value;
};

FFI text_style_t motif_text_style_create() { return new text_style(); }
FFI void motif_text_style_destroy(text_style_t style) { delete style; }

FFI double motif_text_style_get_font_size(text_style_t style) { return style->value.getFontSize(); }
FFI void motif_text_style_set_font_size(text_style_t style, double size) { style->value.setFontSize(size); }

FFI size_t motif_text_style_get_font_families_count(text_style_t style) {
  return style->value.getFontFamilies().size();
}

FFI size_t motif_text_style_get_font_family(text_style_t style, int32_t index, char* buffer) {
  const auto& families = style->value.getFontFamilies();
  if (index < 0 || index >= static_cast<int32_t>(families.size())) return 0;
  const auto& family = families[index];
  if (buffer) {
    strncpy(buffer, family.c_str(), family.size() + 1);
  }
  return family.size();
}

FFI void motif_text_style_set_font_families(text_style_t style, const char** families, int count) {
  std::vector<SkString> sk_families;
  sk_families.reserve(count);

  for (int i = 0; i < count; ++i) sk_families.push_back(SkString(families[i]));
  style->value.setFontFamilies(sk_families);
}

// ---------------------------------------------------------------------------------------------------------------------
// paragraph
// ---------------------------------------------------------------------------------------------------------------------

struct paragraph {
  std::unique_ptr<Paragraph> value;

  bool collected = false;
  std::vector<SkFont> fonts;
  std::vector<line_metrics> lines;
  std::vector<glyph_metrics> glyphs;
  std::vector<uint8_t> glyph_path_verbs;
  std::vector<SkPoint> glyph_path_points;
  glyph_path glyph_path;
};

FFI void motif_paragraph_destroy(paragraph_t p) { delete p; }

FFI void motif_paragraph_layout(paragraph_t p, double width) {
  p->value->layout(width);
  p->collected = false;
}

FFI double motif_paragraph_get_height(paragraph_t p) { return p->value->getHeight(); }
FFI double motif_paragraph_get_longest_line(paragraph_t p) { return p->value->getLongestLine(); }

static void motif_paragraph_collect_metrics(paragraph& p) {
  if (p.collected) return;
  p.collected = true;
  p.fonts.clear();
  p.lines.clear();
  p.glyphs.clear();

  std::vector<LineMetrics> metrics;
  p.value->getLineMetrics(metrics);
  for (const auto& m : metrics) {
    p.lines.push_back({
        static_cast<float>(m.fLeft),
        static_cast<float>(m.fBaseline),
        static_cast<float>(m.fAscent),
        static_cast<float>(m.fDescent),
        static_cast<float>(m.fWidth),
        static_cast<float>(m.fHeight),
        0,
        0,
    });
  }

  uint32_t glyph_start = 0;
  std::vector<SkRect> glyph_bounds;
  p.value->visit([&](int lineIndex, const Paragraph::VisitorInfo* run) {
    if (!run) {
      p.lines[lineIndex].glyph_start = glyph_start;

      glyph_start = p.glyphs.size();
      p.lines[lineIndex].glyph_end = glyph_start;
      return;
    }

    auto font_it = std::find(p.fonts.begin(), p.fonts.end(), run->font);
    if (font_it == p.fonts.end()) font_it = p.fonts.insert(font_it, run->font);
    const uint16_t font = font_it - p.fonts.begin();

    glyph_bounds.resize(run->count);
    run->font.getBounds(run->glyphs, run->count, glyph_bounds.data(), nullptr);

    for (size_t i = 0; i < run->count; i++) {
      const SkPoint point = run->origin + run->positions[i];
      const SkRect box = glyph_bounds[i].makeOffset(point);
      p.glyphs.push_back({
          point.x(),
          point.y(),
          box.left(),
          box.top(),
          box.right(),
          box.bottom(),
          run->glyphs[i],
          font,
      });
    }
  });
}

FFI size_t motif_paragraph_get_line_metrics_count(paragraph_t p) {
  motif_paragraph_collect_metrics(*p);
  return p->lines.size();
}

FFI const line_metrics* motif_paragraph_get_line_metrics(paragraph_t p) {
  motif_paragraph_collect_metrics(*p);
  return p->lines.data();
}

FFI size_t motif_paragraph_get_glyph_metrics_count(paragraph_t p) {
  motif_paragraph_collect_metrics(*p);
  return p->glyphs.size();
}

FFI const glyph_metrics* motif_paragraph_get_glyph_metrics(paragraph_t p) {
  motif_paragraph_collect_metrics(*p);
  return p->glyphs.data();
}

FFI const glyph_path* motif_paragraph_get_glyph_path(paragraph_t paragraph, size_t index) {
  motif_paragraph_collect_metrics(*paragraph);
  const auto& glyph = paragraph->glyphs[index];

  SkPath path;
  paragraph->fonts[glyph.font].getPath(glyph.id, &path);

  
  const uint32_t verbs = path.countVerbs();
  const uint32_t points = path.countPoints();
  paragraph->glyph_path_verbs.resize(verbs);
  paragraph->glyph_path_points.resize(points);
  path.getVerbs(paragraph->glyph_path_verbs.data(), verbs);
  path.getPoints(paragraph->glyph_path_points.data(), points);

  paragraph->glyph_path = {
    verbs,
    points,
    paragraph->glyph_path_verbs.data(),
    reinterpret_cast<const float*>(paragraph->glyph_path_points.data()),
  };

  return &paragraph->glyph_path;
}

// ---------------------------------------------------------------------------------------------------------------------
// paragraph_builder
// ---------------------------------------------------------------------------------------------------------------------

struct paragraph_builder {
  std::unique_ptr<ParagraphBuilder> value;
};

FFI paragraph_builder_t motif_paragraph_builder_create(paragraph_style_t style, font_provider_t provider) {
  const auto& style_ = style->value;
  auto collection_ = provider->collection;

  auto builder = ParagraphBuilder::make(style_, collection_);
  return new paragraph_builder{std::move(builder)};
}

FFI void motif_paragraph_builder_destroy(paragraph_builder_t builder) { delete builder; }

FFI void motif_paragraph_builder_add_text(paragraph_builder_t builder, const char* text) {
  builder->value->addText(text);
}

FFI void motif_paragraph_builder_push_style(paragraph_builder_t builder, text_style_t style) {
  builder->value->pushStyle(style->value);
}

FFI void motif_paragraph_builder_pop_style(paragraph_builder_t builder) { builder->value->pop(); }

FFI paragraph_t motif_paragraph_builder_build(paragraph_builder_t builder) {
  return new paragraph{std::move(builder->value->Build())};
}