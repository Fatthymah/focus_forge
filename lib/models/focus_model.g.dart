// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FocusModelAdapter extends TypeAdapter<FocusModel> {
  @override
  final int typeId = 4;

  @override
  FocusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FocusModel(
      date: fields[0] as String,
      seconds: fields[1] as int,
      userKey: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FocusModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.seconds)
      ..writeByte(2)
      ..write(obj.userKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FocusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
