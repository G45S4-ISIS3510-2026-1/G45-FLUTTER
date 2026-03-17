import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0057c0),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2970e1),
      onPrimaryContainer: Color(0xfffefcff),
      secondary: Color(0xff3859b1),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff83a2ff),
      onSecondaryContainer: Color(0xff05348c),
      tertiary: Color(0xff7b5808),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffecbd68),
      onTertiaryContainer: Color(0xff6b4b00),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf8fa),
      onSurface: Color(0xff1c1b1d),
      onSurfaceVariant: Color(0xff434750),
      outline: Color(0xff747781),
      outlineVariant: Color(0xffc4c6d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a42),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff004396),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff00174b),
      secondaryFixedDim: Color(0xffb4c5ff),
      onSecondaryFixedVariant: Color(0xff1b4198),
      tertiaryFixed: Color(0xffffdea8),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffeebf6a),
      onTertiaryFixedVariant: Color(0xff5e4200),
      surfaceDim: Color(0xffdcd9da),
      surfaceBright: Color(0xfffcf8fa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f4),
      surfaceContainer: Color(0xfff0edee),
      surfaceContainerHigh: Color(0xffeae7e9),
      surfaceContainerHighest: Color(0xffe5e2e3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003376),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c69d9),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002f84),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4869c1),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff493200),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8c6719),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8fa),
      onSurface: Color(0xff111112),
      onSurfaceVariant: Color(0xff33363f),
      outline: Color(0xff4f525c),
      outlineVariant: Color(0xff6a6d77),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff1c69d9),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0050b2),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4869c1),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2d4fa7),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8c6719),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff704f00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc8c6c7),
      surfaceBright: Color(0xfffcf8fa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f4),
      surfaceContainer: Color(0xffeae7e9),
      surfaceContainerHigh: Color(0xffdfdcdd),
      surfaceContainerHighest: Color(0xffd4d1d2),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002a63),
      surfaceTint: Color(0xff005ac4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00459b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00266e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1e439b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3c2900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff614400),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8fa),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c35),
      outlineVariant: Color(0xff464952),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313031),
      inversePrimary: Color(0xffaec6ff),
      primaryFixed: Color(0xff00459b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00306f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1e439b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff002c7c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff614400),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff442f00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbab8b9),
      surfaceBright: Color(0xfffcf8fa),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f0f1),
      surfaceContainer: Color(0xffe5e2e3),
      surfaceContainerHigh: Color(0xffd6d4d5),
      surfaceContainerHighest: Color(0xffc8c6c7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaec6ff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002e6b),
      primaryContainer: Color(0xff4f8eff),
      onPrimaryContainer: Color(0xff00275d),
      secondary: Color(0xffb4c5ff),
      onSecondary: Color(0xff002a77),
      secondaryContainer: Color(0xff83a2ff),
      onSecondaryContainer: Color(0xff05348c),
      tertiary: Color(0xffffdba0),
      onTertiary: Color(0xff422d00),
      tertiaryContainer: Color(0xffecbd68),
      onTertiaryContainer: Color(0xff6b4b00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131314),
      onSurface: Color(0xffe5e2e3),
      onSurfaceVariant: Color(0xffc4c6d1),
      outline: Color(0xff8d909b),
      outlineVariant: Color(0xff434750),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e3),
      inversePrimary: Color(0xff005ac4),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a42),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff004396),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff00174b),
      secondaryFixedDim: Color(0xffb4c5ff),
      onSecondaryFixedVariant: Color(0xff1b4198),
      tertiaryFixed: Color(0xffffdea8),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffeebf6a),
      onTertiaryFixedVariant: Color(0xff5e4200),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff39393a),
      surfaceContainerLowest: Color(0xff0e0e0f),
      surfaceContainerLow: Color(0xff1c1b1d),
      surfaceContainer: Color(0xff201f21),
      surfaceContainerHigh: Color(0xff2a2a2b),
      surfaceContainerHighest: Color(0xff353436),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfdcff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff002356),
      primaryContainer: Color(0xff4f8eff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd2dbff),
      onSecondary: Color(0xff002060),
      secondaryContainer: Color(0xff83a2ff),
      onSecondaryContainer: Color(0xff001749),
      tertiary: Color(0xffffdba0),
      onTertiary: Color(0xff372500),
      tertiaryContainer: Color(0xffecbd68),
      onTertiaryContainer: Color(0xff473100),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131314),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadce8),
      outline: Color(0xffafb1bd),
      outlineVariant: Color(0xff8d909b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e3),
      inversePrimary: Color(0xff004499),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff00102e),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff003376),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff000e34),
      secondaryFixedDim: Color(0xffb4c5ff),
      onSecondaryFixedVariant: Color(0xff002f84),
      tertiaryFixed: Color(0xffffdea8),
      onTertiaryFixed: Color(0xff1a0f00),
      tertiaryFixedDim: Color(0xffeebf6a),
      onTertiaryFixedVariant: Color(0xff493200),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff454445),
      surfaceContainerLowest: Color(0xff070708),
      surfaceContainerLow: Color(0xff1e1d1f),
      surfaceContainer: Color(0xff282829),
      surfaceContainerHigh: Color(0xff333234),
      surfaceContainerHighest: Color(0xff3e3d3f),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecefff),
      surfaceTint: Color(0xffaec6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa8c2ff),
      onPrimaryContainer: Color(0xff000a23),
      secondary: Color(0xffedefff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffaec1ff),
      onSecondaryContainer: Color(0xff000928),
      tertiary: Color(0xffffeed5),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffecbd68),
      onTertiaryContainer: Color(0xff150c00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131314),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffedeffb),
      outlineVariant: Color(0xffc0c2ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e3),
      inversePrimary: Color(0xff004499),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaec6ff),
      onPrimaryFixedVariant: Color(0xff00102e),
      secondaryFixed: Color(0xffdbe1ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb4c5ff),
      onSecondaryFixedVariant: Color(0xff000e34),
      tertiaryFixed: Color(0xffffdea8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffeebf6a),
      onTertiaryFixedVariant: Color(0xff1a0f00),
      surfaceDim: Color(0xff131314),
      surfaceBright: Color(0xff515051),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f21),
      surfaceContainer: Color(0xff313031),
      surfaceContainerHigh: Color(0xff3c3b3c),
      surfaceContainerHighest: Color(0xff474648),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
