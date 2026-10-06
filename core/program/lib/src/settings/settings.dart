part of '../_program.dart';

final class const ProgramSettings({
  final ColorData backgroundColor = .black,
  final String title = 'Untitled',
}) with Equatable {
  static const default_ = ProgramSettings();

  @override
  List<Object?> get props => [backgroundColor, title];

  ProgramSettings copyWith({
    ColorData? backgroundColor,
    String? title,
  }) => .new(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    title: title ?? this.title,
  );
}
