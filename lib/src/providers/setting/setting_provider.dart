import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../network/models/models.dart';

class SettingProvider extends StateNotifier<SettingModel> {
  final String keyBox = 'boxSettingProvider';
  final String _totalGenerateGroupKey = 'totalGenerateGroupKey';
  final String _isAlreadyOnboardingScreenKey = 'isAlreadyOnboardingScreenKey';

  SettingProvider([SettingModel state])
      : super(
          SettingModel(
            isAlreadyOnboardingScreen: false,
            totalGenerateGroup: 1,
          ),
        );

  /// Save setting sharedPreferences Total Group
  Future<void> saveSettingTotalGroup(
    int total, {
    Function(int total) generateTotal,
  }) async {
    final box = Hive.box(keyBox);
    box.put(_totalGenerateGroupKey, total);
    generateTotal(total);
    state = state.copyWith(totalGenerateGroup: total);
  }

  /// Save setting to flag user already success Onboardingscreen
  Future<void> saveSettingOnboardingScreen(bool value) async {
    final box = Hive.box(keyBox);

    box.put(_isAlreadyOnboardingScreenKey, value);
    state = state.copyWith(isAlreadyOnboardingScreen: value);
  }

  Future<void> readSettingProvider() async {
    var box = await Hive.openBox(keyBox);
    final bool sessionOnboarding = box.get(_isAlreadyOnboardingScreenKey, defaultValue: false);
    final int sessionTotalGroup = box.get(_totalGenerateGroupKey, defaultValue: 1);
    state = state.copyWith(
      isAlreadyOnboardingScreen: sessionOnboarding,
      totalGenerateGroup: sessionTotalGroup,
    );
  }
}

final settingProvider = StateNotifierProvider((ref) => SettingProvider());
