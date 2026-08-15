import 'package:flutter/services.dart';

extension _TextEditingValueExtensions on TextEditingValue {
  TextEditingValue iterativeReplaceAll(Pattern pattern, String replacement) {
    var value = this;
    final matches = pattern.allMatches(value.text);
    var offset = 0;

    for (final match in matches) {
      final start = match.start + offset;
      final end = match.end + offset;
      value = value.replaced(TextRange(start: start, end: end), replacement);
      offset += replacement.length - (end - start);
    }

    return value;
  }

  TextEditingValue replacedAll(String replacement) {
    return replaced(TextRange(start: 0, end: text.length), replacement);
  }
}

/// Allows and formats text in E.164 phone number format.
class E164TextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits and a leading '+' character
    final newText = newValue.text.replaceAll(RegExp(r'[^0-9+]'), '');

    // Ensure the first character is '+' if it exists
    if (newText.isNotEmpty && newText[0] != '+') {
      return TextEditingValue(
        text: '+$newText',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // Limit the length to 16 characters (including '+')
    if (newText.length > 16) {
      return oldValue;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

/// Makes sure that there's only one '-' character and it's at the start
TextEditingValue _ensureProperNegative(TextEditingValue value) {
  final firstMinusIndex = value.text.indexOf('-');

  if (firstMinusIndex != -1) {
    return value.replaced(
      TextRange(start: 1, end: value.text.length),
      value.text.substring(1).replaceAll('-', ''),
    );
  }

  return value;
}

/// Ensure only one '.' character (if multiple - keep the first one)
TextEditingValue _ensureProperDecimal(TextEditingValue value) {
  final firstDotIndex = value.text.indexOf('.');

  if (firstDotIndex != -1) {
    return value.replaced(
      TextRange(start: firstDotIndex + 1, end: value.text.length),
      value.text.substring(firstDotIndex + 1).replaceAll('.', ''),
    );
  }

  return value;
}

/// Allows and formats text as an integer.
class IntTextInputFormatter extends TextInputFormatter {
  IntTextInputFormatter({
    this.min = minSafeValue,
    this.max = maxSafeValue,
  }) : assert(min <= max, 'min must be less than or equal to max');

  static const minSafeValue = -9007199254740991; // -(2^53 - 1)
  static const maxSafeValue = 9007199254740991; // 2^53 - 1

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.iterativeReplaceAll(RegExp(r'[^0-9-]'), '');
    value = _ensureProperNegative(value);

    final intValue = int.tryParse(value.text.isEmpty ? '0' : value.text);
    if (intValue == null) return oldValue;

    if (intValue < min) {
      value = value.replacedAll(min.toString());
    } else if (intValue > max) {
      value = value.replacedAll(max.toString());
    }

    return value;
  }
}

/// Allows and formats text as a double.
class DoubleTextInputFormatter extends TextInputFormatter {
  DoubleTextInputFormatter({
    this.min = minSafeValue,
    this.max = maxSafeValue,
  }) : assert(min <= max, 'min must be less than or equal to max');

  static const minSafeValue = -9007199254740991.0; // -(2^53 - 1)
  static const maxSafeValue = 9007199254740991.0; // 2^53 - 1

  final double min;
  final double max;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.iterativeReplaceAll(RegExp(r'[^0-9.-]'), '');
    value = _ensureProperNegative(value);
    value = _ensureProperDecimal(value);

    final doubleValue = double.tryParse(
      value.text.isEmpty || value.text == '-' || value.text == '.' ? '0' : value.text,
    );

    if (doubleValue == null) return oldValue;

    if (doubleValue < min) {
      value = value.replacedAll(min.toString());
    } else if (doubleValue > max) {
      value = value.replacedAll(max.toString());
    }

    return value;
  }
}
