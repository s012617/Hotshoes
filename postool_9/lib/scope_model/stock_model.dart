import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/model/purchase.dart';
import 'package:new_buffalo_pos/model/stock.dart';
import 'package:new_buffalo_pos/services/api_service.dart';
import 'package:new_buffalo_pos/utils/http_helper.dart';
import 'package:new_buffalo_pos/utils/show_alert.dart';

import '../service_locator.dart';
import 'base_model.dart';

class StockModel extends BaseModel {
  APIService _apiService = locator<APIService>();
  List<PurchaseData> _productList = [];
  List<PurchaseData> get productList => _productList;
  String _barCode = "";
  String get barCode => _barCode;
  List<StockData> _stockList = [];
  List<StockData> get stockList => _stockList;

  addProduct(String _code, BuildContext context) async {
    await getStockById(_code, context);
  }

  getStock(int page, BuildContext context) async {
    setState(ViewState.Busy);
    ResponseResultData response = await _apiService.getGoodStorage(page);
    if (response.result) {
      List _jsonList = response.data['data'];
      _jsonList.forEach((it) => _productList.add(PurchaseData.fromJson(it)));
      setState(ViewState.DataFetched);
    } else {
      ShowAlert.show(context, "錯誤", response.data["errorMessage"] ?? "查詢失敗");
      setState(ViewState.Error);
    }
  }

  getStockById(String barCode, BuildContext context) async {
    setState(ViewState.Busy);
    _stockList = [];
    _barCode = barCode;
    ResponseResultData response =
        await _apiService.getGoodStorageByCode(barCode);
    if (response.result) {
      List _jsonList = response.data['data'];
      _jsonList.forEach((it) => _stockList.add(StockData.fromJson(it)));
      setState(ViewState.DataFetched);
    } else {
      ShowAlert.show(context, "錯誤", response.data["errorMessage"] ?? "查詢失敗");
      setState(ViewState.Error);
    }
  }
}
