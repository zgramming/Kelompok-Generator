import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../network/models/models.dart';

final historyBox = Hive.box<HiveHistoryModel>(historyBoxKey);

class HistoryProvider extends StateNotifier<List<HiveHistoryModel>> {
  HistoryProvider([List<HiveHistoryModel> state]) : super(state ?? []);

  Future<void> add(HiveHistoryModel history) async {
    final _uuid = Uuid().v1();
    final result = history.copyWith(id: _uuid);
    await historyBox.put(result.id, result);
    state = [...state, history];
  }

  void delete(String id) async {
    await historyBox.delete(id);
    state = state.where((element) => element.id != id).toList();
  }

  void update(HiveHistoryModel history) async {
    await historyBox.put(history.id, history);
    state = [
      for (final item in state)
        if (item.id == history.id) history else item
    ];
  }
}

final historyProvider = StateNotifierProvider((ref) => HistoryProvider());
