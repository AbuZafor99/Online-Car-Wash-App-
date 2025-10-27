// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_cache_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCacheModelAdapter extends TypeAdapter<HiveCacheModel> {
  @override
  final int typeId = 1;

  @override
  HiveCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCacheModel(
      responseBody: fields[0] as String,
      dataType: fields[1] as String,
      statusCode: fields[2] as int,
      cachedAt: fields[3] as DateTime,
      lastAccessedAt: fields[4] as DateTime,
      size: fields[5] as int,
      etag: fields[6] as String?,
      lastModified: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCacheModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.responseBody)
      ..writeByte(1)
      ..write(obj.dataType)
      ..writeByte(2)
      ..write(obj.statusCode)
      ..writeByte(3)
      ..write(obj.cachedAt)
      ..writeByte(4)
      ..write(obj.lastAccessedAt)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.etag)
      ..writeByte(7)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCacheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HiveCacheModel _$HiveCacheModelFromJson(Map<String, dynamic> json) =>
    HiveCacheModel(
      responseBody: json['responseBody'] as String,
      dataType: json['dataType'] as String,
      statusCode: (json['statusCode'] as num).toInt(),
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
      size: (json['size'] as num).toInt(),
      etag: json['etag'] as String?,
      lastModified: json['lastModified'] as String?,
    );

Map<String, dynamic> _$HiveCacheModelToJson(HiveCacheModel instance) =>
    <String, dynamic>{
      'responseBody': instance.responseBody,
      'dataType': instance.dataType,
      'statusCode': instance.statusCode,
      'cachedAt': instance.cachedAt.toIso8601String(),
      'lastAccessedAt': instance.lastAccessedAt.toIso8601String(),
      'size': instance.size,
      'etag': instance.etag,
      'lastModified': instance.lastModified,
    };
