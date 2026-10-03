#include <include/core/SkFontStyle.h>
#include <modules/skparagraph/include/TextStyle.h>

#include "skia.h"

using namespace skia::textlayout;

// ---------------------------------------------------------------------------------------------------------------------
// Enum conversions
// ---------------------------------------------------------------------------------------------------------------------

namespace {
inline TextAlign to_skia(text_alignment alignment) {
  switch (alignment) {
    case TEXT_ALIGNMENT_LEFT:
      return TextAlign::kLeft;
    case TEXT_ALIGNMENT_RIGHT:
      return TextAlign::kRight;
    case TEXT_ALIGNMENT_CENTER:
      return TextAlign::kCenter;
    case TEXT_ALIGNMENT_JUSTIFY:
      return TextAlign::kJustify;
    case TEXT_ALIGNMENT_START:
      return TextAlign::kStart;
    case TEXT_ALIGNMENT_END:
      return TextAlign::kEnd;
  }
}

inline text_alignment from_skia(TextAlign alignment) {
  switch (alignment) {
    case TextAlign::kLeft:
      return TEXT_ALIGNMENT_LEFT;
    case TextAlign::kRight:
      return TEXT_ALIGNMENT_RIGHT;
    case TextAlign::kCenter:
      return TEXT_ALIGNMENT_CENTER;
    case TextAlign::kJustify:
      return TEXT_ALIGNMENT_JUSTIFY;
    case TextAlign::kStart:
      return TEXT_ALIGNMENT_START;
    case TextAlign::kEnd:
      return TEXT_ALIGNMENT_END;
  }
}

inline SkFontStyle::Slant to_skia(text_style_font_style_slant slant) {
  switch (slant) {
    case TEXT_STYLE_FONT_STYLE_SLANT_UPRIGHT:
      return SkFontStyle::Slant::kUpright_Slant;
    case TEXT_STYLE_FONT_STYLE_SLANT_ITALIC:
      return SkFontStyle::Slant::kItalic_Slant;
    case TEXT_STYLE_FONT_STYLE_SLANT_OBLIQUE:
      return SkFontStyle::Slant::kOblique_Slant;
  }
}

inline text_style_font_style_slant from_skia(SkFontStyle::Slant slant) {
  switch (slant) {
    case SkFontStyle::Slant::kUpright_Slant:
      return TEXT_STYLE_FONT_STYLE_SLANT_UPRIGHT;
    case SkFontStyle::Slant::kItalic_Slant:
      return TEXT_STYLE_FONT_STYLE_SLANT_ITALIC;
    case SkFontStyle::Slant::kOblique_Slant:
      return TEXT_STYLE_FONT_STYLE_SLANT_OBLIQUE;
  }
}

}  // namespace
