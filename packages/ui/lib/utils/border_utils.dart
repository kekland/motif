import 'package:flutter/widgets.dart';

extension ShapeBorderCopyWithBorderSideExtension on ShapeBorder {
  ShapeBorder copyWithBorderSide(BorderSide side) {
    if (this is RoundedRectangleBorder) {
      final shape = this as RoundedRectangleBorder;
      return shape.copyWith(side: side);
    } else if (this is CircleBorder) {
      final shape = this as CircleBorder;
      return shape.copyWith(side: side);
    } else if (this is StadiumBorder) {
      final shape = this as StadiumBorder;
      return shape.copyWith(side: side);
    } else if (this is BeveledRectangleBorder) {
      final shape = this as BeveledRectangleBorder;
      return shape.copyWith(side: side);
    }

    return this;
  }
}
