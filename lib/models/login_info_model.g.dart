// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginInfoAdapter extends TypeAdapter<LoginInfo> {
  @override
  final int typeId = 0;

  @override
  LoginInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginInfo(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.nameOfUser)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
