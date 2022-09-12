/*
* File : App Theme
* Version : 1.0.0
* */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'styles.dart';

class AppTheme {
  static const int themeLight = 1;
  static const int themeDark = 2;

  AppTheme._();

  static CustomAppTheme getCustomAppTheme(int themeMode) {
    if (themeMode == themeLight) {
      return lightCustomAppTheme;
    } else if (themeMode == themeDark) {
      return darkCustomAppTheme;
    }
    return darkCustomAppTheme;
  }

  static TextStyle getTextStyle(TextStyle textStyle,
      {FontWeight fontWeight = FontWeight.w400,
        bool muted = false,
        bool xMuted =false,
        double letterSpacing = 0.15,
        Color? color,
        TextDecoration decoration = TextDecoration.none,
        double? height,
        double wordSpacing = 0,
        double? fontSize,
      }) {
    double finalFontSize = (fontSize ?? textStyle.fontSize) ?? 10;

    Color finalColor;
    if(color==null) {
      finalColor= (xMuted ? textStyle.color?.withAlpha(160) : (muted ? textStyle.color?.withAlpha(200) : textStyle.color)) ?? Styles.lightPrimaryColor;
    }
    else {
      finalColor = xMuted ? color.withAlpha(160) : ( muted ? color.withAlpha(200) : color);
    }



    return getTextStyleWithFontFamily(
      textStyle: TextStyle(
        fontSize: finalFontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        color: finalColor,
        decoration: decoration,
        height: height,
        wordSpacing: wordSpacing,
      ),
    );
  }

  static TextStyle getTextStyleWithFontFamily({TextStyle? textStyle}) {
    // return (textStyle ?? TextStyle()).copyWith(fontFamily: "Mono");
    return GoogleFonts.catamaran(textStyle: textStyle);
  }

  //App Bar Text
  static final TextTheme lightAppBarTextTheme = TextTheme(
    headline1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 102, color: Styles.lightTextColor)),
    headline2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 64, color: Styles.lightTextColor)),
    headline3: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 51, color: Styles.lightTextColor)),
    headline4: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 36, color: Styles.lightTextColor)),
    headline5: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 25, color: Styles.lightTextColor)),
    headline6: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 18, color: Styles.lightTextColor)),
    subtitle1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 17, color: Styles.lightTextColor)),
    subtitle2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Styles.lightTextColor)),
    bodyText1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 16, color: Styles.lightTextColor)),
    bodyText2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 14, color: Styles.lightTextColor)),
    button: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Styles.lightTextColor)),
    caption: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 13, color: Styles.lightTextColor)),
    overline: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 11, color: Styles.lightTextColor)),
  );

  static final TextTheme darkAppBarTextTheme = TextTheme(
    headline1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 102, color: Styles.darkTextColor)),
    headline2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 64, color: Styles.darkTextColor)),
    headline3: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 51, color: Styles.darkTextColor)),
    headline4: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 36, color: Styles.darkTextColor)),
    headline5: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 25, color: Styles.darkTextColor)),
    headline6: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 20, color: Styles.darkTextColor)),
    subtitle1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 17, color: Styles.darkTextColor)),
    subtitle2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Styles.darkTextColor)),
    bodyText1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 16, color: Styles.darkTextColor)),
    bodyText2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 14, color: Styles.darkTextColor)),
    button: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Styles.darkTextColor)),
    caption: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 13, color: Styles.darkTextColor)),
    overline: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 11, color: Styles.darkTextColor)),
  );

  //Text Themes
  static final TextTheme lightTextTheme = TextTheme(
    headline1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 102, color: Color(0xff4a4c4f))),
    headline2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 64, color: Color(0xff4a4c4f))),
    headline3: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 51, color: Color(0xff4a4c4f))),
    headline4: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 36, color: Color(0xff4a4c4f))),
    headline5: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 25, color: Color(0xff4a4c4f))),
    headline6: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 18, color: Color(0xff4a4c4f))),
    subtitle1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 17, color: Color(0xff4a4c4f))),
    subtitle2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
    bodyText1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 16, color: Color(0xff4a4c4f))),
    bodyText2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 14, color: Color(0xff4a4c4f))),
    button: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
    caption: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 13, color: Color(0xff4a4c4f))),
    overline: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 11, color: Color(0xff4a4c4f))),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 102, color: Colors.white)),
    headline2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 64, color: Colors.white)),
    headline3: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 51, color: Colors.white)),
    headline4: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 36, color: Colors.white)),
    headline5: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 25, color: Colors.white)),
    headline6: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 18, color: Colors.white)),
    subtitle1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 17, color: Colors.white)),
    subtitle2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Colors.white)),
    bodyText1: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 16, color: Colors.white)),
    bodyText2: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 14, color: Colors.white)),
    button: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 15, color: Colors.white)),
    caption: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 13, color: Colors.white)),
    overline: getTextStyleWithFontFamily(
        textStyle: const TextStyle(fontSize: 11, color: Colors.white)),
  );

  //Color Themes
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Styles.lightPrimaryColor,
    canvasColor: Colors.transparent,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Styles.lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      //textTheme: lightAppBarTextTheme,
      titleTextStyle: TextStyle(
        color: Styles.lightTextColor,
      ),
      toolbarTextStyle: TextStyle(
        color: Styles.lightTextColor,
      ),
      actionsIconTheme: IconThemeData(
        color: Styles.lightTextColor,
      ),
      color: Styles.lightAppBarColor,
      iconTheme: IconThemeData(color: Styles.lightTextColor, size: 24),
    ),
    navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: Styles.lightPrimaryColor, opacity: 1, size: 24),
        unselectedIconTheme: IconThemeData(color: Styles.lightTextColor, opacity: 1, size: 24),
        backgroundColor: Styles.lightBackgroundColor,
        elevation: 3,
        selectedLabelTextStyle: TextStyle(color: Styles.lightPrimaryColor),
        unselectedLabelTextStyle: TextStyle(color: Styles.lightTextColor),
    ),
    colorScheme: ColorScheme.light(
        primary: Styles.lightPrimaryColor,
        onPrimary: Colors.white,
        primaryVariant: Styles.lightPrimaryVariant,
        secondary: Styles.lightSecondaryColor,
        secondaryVariant: Styles.lightSecondaryVariant,
        onSecondary: Colors.white,
        surface: const Color(0xffe2e7f1),
        background: const Color(0xfff3f4f7),
        onBackground: Styles.lightTextColor,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 1,
      margin: const EdgeInsets.all(0),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 15, color: Color(0xaa495057)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Styles.lightPrimaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.black54)),
    ),
    splashColor: Colors.white.withAlpha(100),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 30
    ),
    textTheme: lightTextTheme,
    indicatorColor: Colors.white,
    disabledColor: const Color(0xffdcc7ff),
    highlightColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Styles.lightPrimaryColor,
        splashColor: Colors.white.withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        focusColor: Styles.lightPrimaryColor,
        hoverColor: Styles.lightPrimaryColor,
        foregroundColor: Colors.white),
    dividerColor: const Color(0xffd1d1d1),
    errorColor: const Color(0xfff0323c),
    cardColor: Colors.white,
    accentColor: Styles.lightPrimaryColor,
    popupMenuTheme: PopupMenuThemeData(
      color: Styles.lightBackgroundColor,
      textStyle: lightTextTheme.bodyText2?.merge(const TextStyle(color: Styles.lightTextColor)),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Styles.lightBackgroundColor, elevation: 2),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Styles.lightTextColor,
      labelColor: Styles.lightPrimaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Styles.lightPrimaryColor, width: 2.0),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Styles.lightPrimaryColor,
      inactiveTrackColor: Styles.lightPrimaryColor.withAlpha(140),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: Styles.lightPrimaryColor,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      canvasColor: Colors.transparent,
      primaryColor: Styles.darkPrimaryColor,
      scaffoldBackgroundColor: Styles.darkBackgroundColor,
      backgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        // textTheme: darkAppBarTextTheme,
        titleTextStyle: TextStyle(
          color: Styles.darkTextColor,
        ),
        toolbarTextStyle: TextStyle(
          color: Styles.darkTextColor,
        ),
        actionsIconTheme: IconThemeData(
          color: Styles.darkTextColor,
        ),
        color: Styles.darkAppBarColor,
        iconTheme: IconThemeData(color: Styles.darkTextColor, size: 24),
      ),
      colorScheme: ColorScheme.dark(
        primary: Styles.darkPrimaryColor,
        primaryVariant: Styles.darkPrimaryVariant,
        secondary: Styles.darkSecondaryColor,
        secondaryVariant: Styles.darkSecondaryVariant,
        background: Colors.black,
        onPrimary: Colors.white,
        onBackground: Colors.white,
        onSecondary: Colors.white,
        surface: const Color(0xff585e63),
      ),
      cardTheme: const CardTheme(
        color: Color(0xff37404a),
        shadowColor: Color(0xff000000),
        elevation: 1,
        margin: EdgeInsets.all(0),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textTheme: darkTextTheme,
      indicatorColor: Colors.white,
      disabledColor: const Color(0xffa3a3a3),
      highlightColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Color(0xff10bbf0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.white70),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: Colors.white70)),
      ),
      dividerColor: const Color(0xffd1d1d1),
      errorColor: Colors.orange,
      cardColor: const Color(0xff282a2b),
      splashColor: Colors.white.withAlpha(100),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Styles.darkPrimaryColor,
          splashColor: Colors.white.withAlpha(100),
          highlightElevation: 8,
          elevation: 4,
          focusColor: Styles.darkPrimaryColor,
          hoverColor: Styles.darkPrimaryColor,
          foregroundColor: Colors.white),
      accentColor: Styles.darkPrimaryColor,
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xff37404a),
        textStyle: lightTextTheme.bodyText2?.merge(const TextStyle(color: Styles.darkTextColor)),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff292929), elevation: 2),
      tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Styles.lightTextColor,
        labelColor: Color(0xff10bbf0),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xff10bbf0), width: 2.0),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xff10bbf0),
        inactiveTrackColor: Styles.darkPrimaryColor.withAlpha(100),
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbColor: const Color(0xff10bbf0),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
        tickMarkShape: const RoundSliderTickMarkShape(),
        inactiveTickMarkColor: Colors.red[100],
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData());

  static ThemeData getThemeFromThemeMode(int themeMode) {
    if (themeMode == themeLight) {
      return lightTheme;
    }
    else if (themeMode == themeDark) {
      return darkTheme;
    }
    return lightTheme;
  }

  static NavigationBarTheme getNavigationThemeFromMode(int themeMode) {
    print(themeMode);
    NavigationBarTheme navigationBarTheme = NavigationBarTheme();
    if (themeMode == themeLight) {
      navigationBarTheme.backgroundColor = Colors.white;
      navigationBarTheme.selectedItemColor = const Color(0xff10bbf0);
      navigationBarTheme.unselectedItemColor = const Color(0xff495057);
      navigationBarTheme.selectedOverlayColor = const Color(0x383d63ff);
    }
    else if (themeMode == themeDark) {
      navigationBarTheme.backgroundColor = const Color(0xff37404a);
      navigationBarTheme.selectedItemColor = const Color(0xff37404a);
      navigationBarTheme.unselectedItemColor = const Color(0xffd1d1d1);
      navigationBarTheme.selectedOverlayColor = const Color(0xffffffff);
    }
    return navigationBarTheme;
  }

  static final CustomAppTheme lightCustomAppTheme = CustomAppTheme(
    bgLayer1: const Color(0xffffffff),
    bgLayer2: const Color(0xfff9f9f9),
    bgLayer3: const Color(0xffe8ecf4),
    bgLayer4: const Color(0xffdcdee3),
    disabledColor: const Color(0xff636363),
    onDisabled: const Color(0xffffffff),
    colorInfo: const Color(0xffff784b),
    colorWarning: const Color(0xffffc837),
    colorSuccess: const Color(0xff3cd278),
    shadowColor: const Color(0xffeaeaea),
    onInfo: const Color(0xffffffff),
    onSuccess: const Color(0xffffffff),
    onWarning: const Color(0xffffffff),
    colorError: const Color(0xfff0323c),
    onError: const Color(0xffffffff),);
  static final CustomAppTheme darkCustomAppTheme = CustomAppTheme(
    bgLayer1: const Color(0xff212429),
    bgLayer2: const Color(0xff282930),
    bgLayer3: const Color(0xff303138),
    bgLayer4: const Color(0xff383942),
    disabledColor: const Color(0xffbababa),
    onDisabled: const Color(0xff000000),
    colorInfo: const Color(0xffff784b),
    colorWarning: const Color(0xffffc837),
    colorSuccess: const Color(0xff3cd278),
    shadowColor: const Color(0xff1a1a1a),
    onInfo: const Color(0xffffffff),
    onSuccess: const Color(0xffffffff),
    onWarning: const Color(0xffffffff),
    colorError: const Color(0xfff0323c),
    onError: const Color(0xffffffff),
  );
}

class CustomAppTheme {
  final Color bgLayer1,
      bgLayer2,
      bgLayer3,
      bgLayer4,
      disabledColor,
      onDisabled,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError;

  CustomAppTheme({
    this.bgLayer1 = const Color(0xffffffff),
    this.bgLayer2 = const Color(0xfff8faff),
    this.bgLayer3 = const Color(0xffeef2fa),
    this.bgLayer4 = const Color(0xffdcdee3),
    this.disabledColor = const Color(0xffdcc7ff),
    this.onDisabled = const Color(0xffffffff),
    this.colorWarning = const Color(0xffffc837),
    this.colorInfo = const Color(0xffff784b),
    this.colorSuccess = const Color(0xff3cd278),
    this.shadowColor = const Color(0xff1f1f1f),
    this.onInfo = const Color(0xffffffff),
    this.onWarning = const Color(0xffffffff),
    this.onSuccess = const Color(0xffffffff),
    this.colorError = const Color(0xfff0323c),
    this.onError = const Color(0xffffffff),
  });
}

class NavigationBarTheme {
  Color? backgroundColor,
      selectedItemIconColor,
      selectedItemTextColor,
      selectedItemColor,
      selectedOverlayColor,
      unselectedItemIconColor,
      unselectedItemTextColor,
      unselectedItemColor;
}
