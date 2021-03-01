import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../history/history_screen.dart';
import '../../../providers/providers.dart';
import './form_setting_total_group.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({
    Key key,
  }) : super(key: key);

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      GlobalFunction.showToast(message: e.toString(), toastType: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: UserAccountsDrawerHeader(
              accountName: const Text('Kelompok Generator'),
              accountEmail: SizedBox(),
              decoration: BoxDecoration(
                color: colorPallete.primaryColor,
                backgroundBlendMode: BlendMode.darken,
                image: DecorationImage(
                  image: AssetImage("${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}"),
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerMenu(
                    showDivider: true,
                    title: 'Ubah total kelompok',
                    trailing: CircleAvatar(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer(builder: (context, watch, child) {
                            final settingTotal = watch(settingProvider.state).totalGenerateGroup;
                            return Text('$settingTotal');
                          }),
                        ),
                      ),
                      backgroundColor: colorPallete.accentColor,
                      foregroundColor: colorPallete.white,
                      radius: sizes.isMobileLayout(context)
                          ? sizes.width(context) * .035
                          : sizes.width(context) * .015,
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => FormSettingTotalGroup(),
                      );
                    },
                  ),
                  DrawerMenu(
                    title: 'Riwayat',
                    showDivider: true,
                    trailing: Icon(Icons.history),
                    onTap: () => Navigator.of(context).pushNamed(HistoryScreen.routeNamed),
                  ),
                  DrawerMenu(
                    showDivider: true,
                    trailing: Icon(
                      Icons.copyright,
                    ),
                    title: 'Icon Copyright',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ShowImageAsset(
                                      imageUrl: '${appConfig.urlImageAsset}/freepik.png',
                                      imageSize: 5),
                                  ShowImageAsset(
                                      imageUrl: '${appConfig.urlImageAsset}/flaticon.png',
                                      imageSize: 5),
                                ],
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Icons made by ',
                                  style: TextStyle(color: colorPallete.black),
                                  children: [
                                    TextSpan(
                                      text: 'Freepik ',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl('https://www.freepik.com');
                                        },
                                      style: TextStyle(
                                        color: colorPallete.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: 'from '),
                                    TextSpan(
                                      text: 'www.flaticon.com',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          await launchUrl('https://www.flaticon.com/');
                                        },
                                      style: TextStyle(
                                        color: colorPallete.blue,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  DrawerMenu(
                    showDivider: true,
                    trailing: Icon(
                      Icons.star_border_rounded,
                    ),
                    title: 'Berikan rating',
                    onTap: () {
                      LaunchReview.launch(
                        androidAppId: 'reynando.zeffry.kelompok_generator',
                      );
                    },
                  ),
                  DrawerMenu(
                    showDivider: true,
                    trailing: Icon(
                      Icons.mobile_friendly,
                    ),
                    title: 'Tentang aplikasi',
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationIcon: ShowImageAsset(
                          imageUrl: '${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}',
                          imageSize: 2,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
