import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/providers.dart';
import '../welcome/welcome_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPage(
        onPageChanged: (value) => print('value pageChanged'),
        onClickFinish: () async => await context
            .read(settingProvider)
            .saveSettingOnboardingScreen(true)
            .whenComplete(
                () => Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeNamed)),
        onClickNext: (value) => print('value next'),
        paddingCircleIndicator: const EdgeInsets.all(10.0),
        iconNext: Icon(
          Icons.chevron_right_rounded,
          size: sizes.width(context) / 10,
          color: colorPallete.white,
          key: UniqueKey(),
        ),
        iconFinish: Icon(
          Icons.check,
          size: sizes.width(context) / 10,
          color: colorPallete.white,
          key: UniqueKey(),
        ),
        items: [
          OnboardingItem(
            logo: ShowImageAsset(
              imageUrl: '${appConfig.urlImageAsset}/paint-palette.png',
              imageSize: 1.5,
            ),
            title: Text(
              'Tampilan yang menarik',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: colorPallete.white,
              ),
            ),
          ),
          OnboardingItem(
            logo: ShowImageAsset(
              imageUrl: '${appConfig.urlImageAsset}/layer.png',
              imageSize: 1.5,
            ),
            title: Text(
              'Mengorganisasi Kelompok',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: colorPallete.white,
              ),
            ),
          ),
          OnboardingItem(
            logo: ShowImageAsset(
              imageUrl: '${appConfig.urlImageAsset}/pdf.png',
              imageSize: 1.5,
            ),
            title: Text(
              'Export sebagai PDF',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: colorPallete.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
