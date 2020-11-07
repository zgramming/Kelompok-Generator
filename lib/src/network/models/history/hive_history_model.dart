import 'package:hive/hive.dart';

part 'hive_history_model.g.dart';

const historyBoxKey = 'history_box';

@HiveType(typeId: 1)
class HiveHistoryModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String encodedPersons;
  @HiveField(2)
  String base64PDF;
  @HiveField(3)
  DateTime createdAt;

  HiveHistoryModel({
    this.id,
    this.encodedPersons,
    this.base64PDF,
    this.createdAt,
  });

  HiveHistoryModel copyWith({
    String id,
    String encodedPersons,
    String base64PDF,
    DateTime createdAt,
  }) {
    return HiveHistoryModel(
      id: id ?? this.id,
      encodedPersons: encodedPersons ?? this.encodedPersons,
      base64PDF: base64PDF ?? this.base64PDF,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
