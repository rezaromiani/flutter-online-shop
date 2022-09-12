import 'package:flutter/material.dart';
import 'package:nike_store/data/favorite_manager.dart';
import 'package:nike_store/data/repository/auth_repository.dart';
import 'package:nike_store/theme.dart';

import 'package:nike_store/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultFontStyle = TextStyle(
        fontFamily: "IranYekan", color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          listTileTheme: const ListTileThemeData(
            iconColor: LightThemeColors.secondaryColor,
            textColor: LightThemeColors.secondaryColor,
            minLeadingWidth: 12,
          ),
          hintColor: LightThemeColors.secondaryTextColor,
          inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          LightThemeColors.primaryTextColor.withOpacity(0.1)))),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              extendedTextStyle: TextStyle(
                  fontFamily: "IranYekan", fontWeight: FontWeight.w700)),
          snackBarTheme: SnackBarThemeData(
              contentTextStyle: defaultFontStyle.apply(color: Colors.white)),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: LightThemeColors.primaryTextColor),
          textTheme: TextTheme(
              bodyText2: defaultFontStyle,
              button: defaultFontStyle,
              subtitle1: defaultFontStyle.copyWith(
                  color: LightThemeColors.secondaryTextColor),
              caption: defaultFontStyle.apply(
                  color: LightThemeColors.secondaryTextColor),
              headline6: defaultFontStyle.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          colorScheme: const ColorScheme.light(
              primary: LightThemeColors.primaryColor,
              secondary: LightThemeColors.secondaryColor,
              onSurface: LightThemeColors.secondaryColor,
              surfaceVariant: Color(0xFFf5f5f5),
              onSecondary: LightThemeColors.secondaryTextColor)),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
