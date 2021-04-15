import 'package:json_annotation/json_annotation.dart';

part 'stock.g.dart';

@JsonSerializable(nullable: false)
class StockData {
  String goodId;
  String sizeName;
  double quantity;

  StockData(this.goodId, this.sizeName, this.quantity);

  factory StockData.fromJson(Map<String, dynamic> json) =>
      _$StockDataFromJson(json);
  Map<String, dynamic> toJson() => _$StockDataToJson(this);
}
