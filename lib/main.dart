import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'src/app.dart';
import 'src/network/models/models.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();

  Hive
    ..init(document.path)
    ..registerAdapter(
      HiveHistoryModelAdapter(),
    );

  await Hive.openBox<HiveHistoryModel>(historyBoxKey);

  appConfig.configuration(
    headerFont: 'Montserrat',
    defaultFont: 'Poppins',
  );
  colorPallete.configuration(
    primaryColor: Color(0xFF9e2a2b),
    accentColor: Color(0xFFAE355B),
  );

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
