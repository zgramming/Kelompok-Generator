import 'package:hive/hive.dart';

part 'hive_history_model.g.dart';

const historyBoxKey = 'history_box';

@HiveType(typeId: 1)
class HiveHistoryModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String nameGroup;
  @HiveField(2)
  String encodedPersons;
  @HiveField(3)
  String base64PDF;
  @HiveField(4)
  DateTime createdAt;

  HiveHistoryModel({
    this.id,
    this.nameGroup,
    this.encodedPersons,
    this.base64PDF,
    this.createdAt,
  });

  HiveHistoryModel copyWith({
    String id,
    String nameGroup,
    String encodedPersons,
    String base64PDF,
    DateTime createdAt,
  }) {
    return HiveHistoryModel(
      id: id ?? this.id,
      nameGroup: nameGroup ?? this.nameGroup,
      encodedPersons: encodedPersons ?? this.encodedPersons,
      base64PDF: base64PDF ?? this.base64PDF,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
