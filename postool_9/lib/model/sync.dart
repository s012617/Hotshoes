import 'package:json_annotation/json_annotation.dart';
import 'package:new_buffalo_pos/model/product.dart';
import 'package:new_buffalo_pos/model/purchase.dart';

part 'sync.g.dart';

@JsonSerializable(nullable: false)
class SyncData {
  int id;
  String mode;
  List<ProductDetail> data;

  SyncData(this.id, this.mode, this.data);

  factory SyncData.fromJson(Map<String, dynamic> json) =>
      _$SyncDataFromJson(json);
  Map<String, dynamic> toJson() => _$SyncDataToJson(this);
}
