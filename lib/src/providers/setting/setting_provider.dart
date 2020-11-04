import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/models/models.dart';

const _totalGenerateGroupKey = 'totalGenerateGroupKey';

class SettingProvider extends StateNotifier<SettingModel> {
  SettingProvider([SettingModel state]) : super(state ?? SettingModel());

  Future<bool> save(
    int total, {
    Function(int total) generateTotal,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final result = await pref.setInt(_totalGenerateGroupKey, total);
    generateTotal(total);
    state = state.copyWith(totalGenerateGroup: total);
    return result;
  }

  Future<void> read() async {
    final pref = await SharedPreferences.getInstance();
    final result = pref.getInt(_totalGenerateGroupKey) ?? 0;
    state = state.copyWith(totalGenerateGroup: result);
    print(result);
  }
}

final settingProvider = StateNotifierProvider((ref) => SettingProvider());
