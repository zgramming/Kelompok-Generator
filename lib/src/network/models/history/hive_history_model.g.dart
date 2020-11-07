// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveHistoryModelAdapter extends TypeAdapter<HiveHistoryModel> {
  @override
  final int typeId = 1;

  @override
  HiveHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveHistoryModel(
      id: fields[0] as String,
      encodedPersons: fields[1] as String,
      base64PDF: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveHistoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.encodedPersons)
      ..writeByte(2)
      ..write(obj.base64PDF)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
