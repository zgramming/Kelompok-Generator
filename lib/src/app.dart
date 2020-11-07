import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:kelompok_generator/src/screens/history/widgets/history_list.dart';

import './screens/splash/splash_screen.dart';
import './screens/generate_result/generate_result_screen.dart';
import './screens/history/history_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        fontFamily: appConfig.defaultFont,
        scaffoldBackgroundColor: colorPallete.backgroundColor5,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        GenerateResultScreen.routeNamed: (ctx) => GenerateResultScreen(
              generateResult: ModalRoute.of(ctx).settings.arguments,
            ),
        HistoryScreen.routeNamed: (ctx) => HistoryScreen(),
        PDFPreviewScreen.routeNamed: (ctx) => PDFPreviewScreen(
              pathPDF: ModalRoute.of(ctx).settings.arguments,
            )
      },
    );
  }
}
