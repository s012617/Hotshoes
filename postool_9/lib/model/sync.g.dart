// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncData _$SyncDataFromJson(Map<String, dynamic> json) {
  return SyncData(
    json['id'] as int,
    json['mode'] as String,
    (json['data'] as List)
        .map((e) => ProductDetail.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SyncDataToJson(SyncData instance) => <String, dynamic>{
      'id': instance.id,
      'mode': instance.mode,
      'data': instance.data,
    };
