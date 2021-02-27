import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  const SettingModel({
    this.totalGenerateGroup,
    this.isAlreadyOnboardingScreen,
  });

  final int totalGenerateGroup;
  final bool isAlreadyOnboardingScreen;

  @override
  List<Object> get props => [totalGenerateGroup, isAlreadyOnboardingScreen];

  @override
  bool get stringify => true;

  SettingModel copyWith({
    int totalGenerateGroup,
    bool isAlreadyOnboardingScreen,
  }) =>
      SettingModel(
        totalGenerateGroup: totalGenerateGroup ?? this.totalGenerateGroup,
        isAlreadyOnboardingScreen: isAlreadyOnboardingScreen ?? this.isAlreadyOnboardingScreen,
      );
}
