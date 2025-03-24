// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EntryAdapter extends TypeAdapter<Entry> {
  @override
  final int typeId = 0;

  @override
  Entry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Entry(
      fields[0] as String,
      fields[1] as DateTime,
      exitTime: fields[2] as DateTime?,
      isPaid: fields[3] as bool,
      vehicleType: fields[4] as String, // Updated to include vehicleType
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..writeByte(5) // Updated to 5 fields
      ..writeByte(0)
      ..write(obj.carPlate)
      ..writeByte(1)
      ..write(obj.entryTime)
      ..writeByte(2)
      ..write(obj.exitTime)
      ..writeByte(3)
      ..write(obj.isPaid)
      ..writeByte(4)
      ..write(obj.vehicleType); // Updated to include vehicleType
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
