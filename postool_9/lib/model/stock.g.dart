// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockData _$StockDataFromJson(Map<String, dynamic> json) {
  return StockData(
    json['goodId'] as String,
    json['sizeName'] as String,
    (json['quantity'] as num).toDouble(),
  );
}

Map<String, dynamic> _$StockDataToJson(StockData instance) => <String, dynamic>{
      'goodId': instance.goodId,
      'sizeName': instance.sizeName,
      'quantity': instance.quantity,
    };
