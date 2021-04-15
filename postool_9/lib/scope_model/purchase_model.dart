import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/model/purchase.dart';
import 'package:new_buffalo_pos/scope_model/base_model.dart';
import 'package:new_buffalo_pos/service_locator.dart';
import 'package:new_buffalo_pos/services/api_service.dart';
import 'package:new_buffalo_pos/utils/http_helper.dart';
import 'package:new_buffalo_pos/utils/show_alert.dart';

class PurchaseModel extends BaseModel {
  APIService _apiService = locator<APIService>();
  List<PurchaseData> _productList = [];
  List<PurchaseData> get productList => _productList;
  String _shipId = "";

  addProduct(String _code, BuildContext context) async {
    await getPruchaseProduct(_code, context);
  }

  getPruchaseProduct(String shipId, BuildContext context) async {
    setState(ViewState.Busy);
    _productList = [];
    _shipId = shipId;
    ResponseResultData response = await _apiService.getStockById(shipId);
    if (response.result) {
      List _jsonList = response.data['data'];
      _jsonList.forEach((it) => _productList.add(PurchaseData.fromJson(it)));
      setState(ViewState.DataFetched);
    } else {
      ShowAlert.show(context, "錯誤", response.data["errorMessage"] ?? "查詢失敗");
      setState(ViewState.Error);
    }
  }

  confirmPurchase(List<PurchaseData> productList, BuildContext context) async {
    setState(ViewState.Busy);
    List<Map> _jsonList = [];
    productList.forEach((it) => _jsonList.add(it.toJson()));
    print(_jsonList);
    ResponseResultData response =
        await _apiService.confirmStock(_shipId, _jsonList);
    if (response.result) {
      setState(ViewState.DataFetched);
      Navigator.pop(context);
    } else {
      ShowAlert.show(context, "錯誤", response.data["errorMessage"] ?? "認證失敗");
      setState(ViewState.Error);
    }
  }
}
