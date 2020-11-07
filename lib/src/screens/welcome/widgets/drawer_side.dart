import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../history/history_screen.dart';
import '../../../providers/providers.dart';
import './form_setting_total_group.dart';

class DrawerSide extends StatelessWidget {
  const DrawerSide({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(sizes.isMobileLayout(context));
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
                      Icons.mobile_friendly,
                    ),
                    title: 'Tentang aplikasi',
                    onTap: () {
                      showLicensePage(context: context);
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
