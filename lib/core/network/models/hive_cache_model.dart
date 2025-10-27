// lib/core/network/models/hive_cache_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hive_cache_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class HiveCacheModel {
  @HiveField(0)
  final String responseBody;

  @HiveField(1)
  final String dataType;

  @HiveField(2)
  final int statusCode;

  @HiveField(3)
  final DateTime cachedAt;

  @HiveField(4)
  DateTime lastAccessedAt;

  @HiveField(5)
  final int size;

  @HiveField(6)
  final String? etag;

  @HiveField(7)
  final String? lastModified;

  HiveCacheModel({
    required this.responseBody,
    required this.dataType,
    required this.statusCode,
    required this.cachedAt,
    required this.lastAccessedAt,
    required this.size,
    this.etag,
    this.lastModified,
  });

  factory HiveCacheModel.fromJson(Map<String, dynamic> json) =>
      _$HiveCacheModelFromJson(json);

  Map<String, dynamic> toJson() => _$HiveCacheModelToJson(this);
}
