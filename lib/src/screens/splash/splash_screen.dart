import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      context.read(settingProvider).read();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenTemplate(
        navigateAfterSplashScreen: (ctx) => WelcomeScreen(),
        copyRightVersion: CopyRightVersion(),
        image: ShowImageAsset(
          imageUrl: "${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}",
          imageSize: 3,
        ),
      ),
    );
  }
}
