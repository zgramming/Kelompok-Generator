import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../onboarding/onboarding_screen.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _readSettingProvider();
      context.read(settingProvider).readSettingProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (_, watch, __) {
          // Karena namanya sama , gunakan alias
          final setProvider = watch(settingProvider.state);

          return SplashScreenTemplate(
            navigateAfterSplashScreen: (ctx) {
              /// Check if user already pass OnboardingScreen
              if (setProvider.isAlreadyOnboardingScreen) {
                return WelcomeScreen();
              }
              return OnboardingScreen();
            },
            copyRightVersion: CopyRightVersion(),
            image: ShowImageAsset(
              imageUrl: "${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}",
              imageSize: 3,
            ),
          );
        },
      ),
    );
  }
}
