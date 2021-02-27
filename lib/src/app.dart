import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

import 'package:google_fonts/google_fonts.dart';

import './screens/generate_result/generate_result_screen.dart';
import './screens/history/history_screen.dart';
import './screens/splash/splash_screen.dart';
import 'screens/history/widgets/history_list.dart';
import 'screens/welcome/welcome_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        scaffoldBackgroundColor: colorPallete.backgroundColor5,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
      routes: {
        WelcomeScreen.routeNamed: (ctx) => WelcomeScreen(),
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
