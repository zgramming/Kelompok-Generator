class SettingModel {
  final int totalGenerateGroup;
  SettingModel({
    this.totalGenerateGroup,
  });

  SettingModel copyWith({
    int totalGenerateGroup,
  }) {
    return SettingModel(
      totalGenerateGroup: totalGenerateGroup ?? this.totalGenerateGroup,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGenerateGroup': totalGenerateGroup,
    };
  }

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SettingModel(
      totalGenerateGroup: json['totalGenerateGroup'],
    );
  }

  @override
  String toString() => 'SettingModel(totalGenerateGroup: $totalGenerateGroup)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SettingModel && o.totalGenerateGroup == totalGenerateGroup;
  }

  @override
  int get hashCode => totalGenerateGroup.hashCode;
}
