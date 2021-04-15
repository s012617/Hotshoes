
import 'package:json_annotation/json_annotation.dart';

part 'purchase.g.dart';

@JsonSerializable(nullable: false)
class PurchaseData {
  String barCode;
  double quantity;

  PurchaseData(this.barCode, this.quantity);

  factory PurchaseData.fromJson(Map<String, dynamic> json) => _$PurchaseDataFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseDataToJson(this);
}