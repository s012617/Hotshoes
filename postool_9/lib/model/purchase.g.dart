// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseData _$PurchaseDataFromJson(Map<String, dynamic> json) {
  return PurchaseData(
    json['barCode'] as String,
    (json['quantity'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PurchaseDataToJson(PurchaseData instance) =>
    <String, dynamic>{
      'barCode': instance.barCode,
      'quantity': instance.quantity,
    };
