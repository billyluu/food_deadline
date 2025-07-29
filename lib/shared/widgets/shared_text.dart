import 'package:flutter/material.dart';
import 'dart:ui' as ui show TextHeightBehavior;
import 'package:food_deadline/generated/app_string.s.dart';
import 'package:food_deadline/widgets/base/base_text.dart';

class SharedText extends StatelessWidget {
  const SharedText({
    this.data,
    this.appString,
    this.textSpan,
    this.style,
    this.textAlign,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  });

  final String? data;
  final AppString? appString;
  final InlineSpan? textSpan;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const SharedText.basic(
    this.data, {
    this.style,
    this.textAlign,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  })  : appString = null,
        textSpan = null;

  const SharedText.i18n(
    AppString this.appString, {
    this.style,
    this.textAlign,
    this.strutStyle,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  })  : data = null,
        textSpan = null;

  const SharedText.rich(
    this.textSpan, {
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    super.key,
  })  : data = null,
        appString = null;

  @override
  Widget build(BuildContext context) {
    return BaseText(
      data: data,
      appString: appString,
      textSpan: textSpan,
      textAlign: textAlign,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

class CommonTextStyle {
  static TextStyle textStyle({Color? color}) => TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleLarge({Color? color}) => TextStyle(
        color: color,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleSmall({Color? color}) => TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );
}
