import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../network/models/history/hive_history_model.dart';
import '../../network/models/models.dart';

import './widgets/history_list.dart';

class HistoryScreen extends StatelessWidget {
  static const routeNamed = '/history-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Riwayat'),
      ),
      body: ValueListenableBuilder<Box<HiveHistoryModel>>(
        valueListenable: Hive.box<HiveHistoryModel>(historyBoxKey).listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return Center(
              child: Text('Riwayat masih kosong'),
            );
          }
          final histories = box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return GroupedListView<HiveHistoryModel, DateTime>(
            elements: histories,
            groupBy: (element) {
              return DateTime(
                element.createdAt.year,
                element.createdAt.month,
                element.createdAt.day,
              );
            },
            groupSeparatorBuilder: (date) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '${GlobalFunction.formatYearMonthDaySpecific(date)}',
                style: appTheme.headline6(context).copyWith(
                      fontFamily: appConfig.headerFont,
                    ),
              ),
            ),
            indexedItemBuilder: (context, history, index) => HistoryList(
              index: index,
              history: history,
            ),
          );
        },
      ),
    );
  }
}
