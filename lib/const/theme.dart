import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff146a5f),
      surfaceTint: Color(0xff146a5f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff91ddcf),
      onPrimaryContainer: Color(0xff056358),
      secondary: Color(0xff5c5f5a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff7f9f2),
      onSecondaryContainer: Color(0xff6f736d),
      tertiary: Color(0xff715571),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffe8c5e5),
      onTertiaryContainer: Color(0xff6b506a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7faf8),
      onSurface: Color(0xff181c1b),
      onSurfaceVariant: Color(0xff3f4946),
      outline: Color(0xff6f7976),
      outlineVariant: Color(0xffbec9c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3130),
      inversePrimary: Color(0xff89d4c7),
      primaryFixed: Color(0xffa4f1e2),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff89d4c7),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffe1e3dc),
      onSecondaryFixed: Color(0xff191c18),
      secondaryFixedDim: Color(0xffc5c7c1),
      onSecondaryFixedVariant: Color(0xff444843),
      tertiaryFixed: Color(0xfffcd8f8),
      onTertiaryFixed: Color(0xff29132b),
      tertiaryFixedDim: Color(0xffdebcdc),
      onTertiaryFixedVariant: Color(0xff583e58),
      surfaceDim: Color(0xffd8dbd9),
      surfaceBright: Color(0xfff7faf8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f2),
      surfaceContainer: Color(0xffecefec),
      surfaceContainerHigh: Color(0xffe6e9e7),
      surfaceContainerHighest: Color(0xffe0e3e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003e36),
      surfaceTint: Color(0xff146a5f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff29796d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff343733),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6b6e69),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff462e47),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff816480),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7faf8),
      onSurface: Color(0xff0e1211),
      onSurfaceVariant: Color(0xff2e3836),
      outline: Color(0xff4a5552),
      outlineVariant: Color(0xff656f6c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3130),
      inversePrimary: Color(0xff89d4c7),
      primaryFixed: Color(0xff29796d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006055),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6b6e69),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff525651),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff816480),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff674c67),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc4c7c5),
      surfaceBright: Color(0xfff7faf8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f2),
      surfaceContainer: Color(0xffe6e9e7),
      surfaceContainerHigh: Color(0xffdadddb),
      surfaceContainerHighest: Color(0xffcfd2d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00332c),
      surfaceTint: Color(0xff146a5f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00534a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2a2d29),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff474a45),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3b243c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5b405b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7faf8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e2c),
      outlineVariant: Color(0xff414b49),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3130),
      inversePrimary: Color(0xff89d4c7),
      primaryFixed: Color(0xff00534a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003a33),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff474a45),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff30342f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5b405b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff422a43),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6b9b8),
      surfaceBright: Color(0xfff7faf8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef1ef),
      surfaceContainer: Color(0xffe0e3e1),
      surfaceContainerHigh: Color(0xffd2d5d3),
      surfaceContainerHighest: Color(0xffc4c7c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffadfaeb),
      surfaceTint: Color(0xff89d4c7),
      onPrimary: Color(0xff003731),
      primaryContainer: Color(0xff91ddcf),
      onPrimaryContainer: Color(0xff056358),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2e312d),
      secondaryContainer: Color(0xffe1e3dc),
      onSecondaryContainer: Color(0xff626560),
      tertiary: Color(0xffffe4fb),
      onTertiary: Color(0xff402841),
      tertiaryContainer: Color(0xffe8c5e5),
      onTertiaryContainer: Color(0xff6b506a),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101413),
      onSurface: Color(0xffe0e3e1),
      onSurfaceVariant: Color(0xffbec9c5),
      outline: Color(0xff889390),
      outlineVariant: Color(0xff3f4946),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e1),
      inversePrimary: Color(0xff146a5f),
      primaryFixed: Color(0xffa4f1e2),
      onPrimaryFixed: Color(0xff00201c),
      primaryFixedDim: Color(0xff89d4c7),
      onPrimaryFixedVariant: Color(0xff005047),
      secondaryFixed: Color(0xffe1e3dc),
      onSecondaryFixed: Color(0xff191c18),
      secondaryFixedDim: Color(0xffc5c7c1),
      onSecondaryFixedVariant: Color(0xff444843),
      tertiaryFixed: Color(0xfffcd8f8),
      onTertiaryFixed: Color(0xff29132b),
      tertiaryFixedDim: Color(0xffdebcdc),
      onTertiaryFixedVariant: Color(0xff583e58),
      surfaceDim: Color(0xff101413),
      surfaceBright: Color(0xff363a39),
      surfaceContainerLowest: Color(0xff0b0f0e),
      surfaceContainerLow: Color(0xff181c1b),
      surfaceContainer: Color(0xff1c201f),
      surfaceContainerHigh: Color(0xff272b2a),
      surfaceContainerHighest: Color(0xff323634),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffadfaeb),
      surfaceTint: Color(0xff89d4c7),
      onPrimary: Color(0xff003731),
      primaryContainer: Color(0xff91ddcf),
      onPrimaryContainer: Color(0xff00443c),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff2e312d),
      secondaryContainer: Color(0xffe1e3dc),
      onSecondaryContainer: Color(0xff464944),
      tertiary: Color(0xffffe4fb),
      onTertiary: Color(0xff402841),
      tertiaryContainer: Color(0xffe8c5e5),
      onTertiaryContainer: Color(0xff4d344d),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101413),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dfdb),
      outline: Color(0xffa9b4b1),
      outlineVariant: Color(0xff88938f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e1),
      inversePrimary: Color(0xff005248),
      primaryFixed: Color(0xffa4f1e2),
      onPrimaryFixed: Color(0xff001511),
      primaryFixedDim: Color(0xff89d4c7),
      onPrimaryFixedVariant: Color(0xff003e36),
      secondaryFixed: Color(0xffe1e3dc),
      onSecondaryFixed: Color(0xff0f120e),
      secondaryFixedDim: Color(0xffc5c7c1),
      onSecondaryFixedVariant: Color(0xff343733),
      tertiaryFixed: Color(0xfffcd8f8),
      onTertiaryFixed: Color(0xff1e0920),
      tertiaryFixedDim: Color(0xffdebcdc),
      onTertiaryFixedVariant: Color(0xff462e47),
      surfaceDim: Color(0xff101413),
      surfaceBright: Color(0xff414544),
      surfaceContainerLowest: Color(0xff050807),
      surfaceContainerLow: Color(0xff1a1e1d),
      surfaceContainer: Color(0xff252928),
      surfaceContainerHigh: Color(0xff2f3332),
      surfaceContainerHighest: Color(0xff3a3e3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb2fff0),
      surfaceTint: Color(0xff89d4c7),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff91ddcf),
      onPrimaryContainer: Color(0xff001f1b),
      secondary: Color(0xffffffff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe1e3dc),
      onSecondaryContainer: Color(0xff282b27),
      tertiary: Color(0xffffeafa),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe8c5e5),
      onTertiaryContainer: Color(0xff29132a),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff101413),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2ef),
      outlineVariant: Color(0xffbac5c1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e1),
      inversePrimary: Color(0xff005248),
      primaryFixed: Color(0xffa4f1e2),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff89d4c7),
      onPrimaryFixedVariant: Color(0xff001511),
      secondaryFixed: Color(0xffe1e3dc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc5c7c1),
      onSecondaryFixedVariant: Color(0xff0f120e),
      tertiaryFixed: Color(0xfffcd8f8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdebcdc),
      onTertiaryFixedVariant: Color(0xff1e0920),
      surfaceDim: Color(0xff101413),
      surfaceBright: Color(0xff4d514f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c201f),
      surfaceContainer: Color(0xff2d3130),
      surfaceContainerHigh: Color(0xff383c3b),
      surfaceContainerHighest: Color(0xff444846),
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
     scaffoldBackgroundColor: colorScheme.background,
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
