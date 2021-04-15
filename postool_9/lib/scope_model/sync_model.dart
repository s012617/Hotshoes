import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/model/product.dart';
import 'package:new_buffalo_pos/model/sync.dart';
import 'package:new_buffalo_pos/scope_model/base_model.dart';
import 'package:new_buffalo_pos/service_locator.dart';
import 'package:new_buffalo_pos/services/api_service.dart';
import 'package:new_buffalo_pos/utils/db_helper.dart';
import 'package:new_buffalo_pos/utils/http_helper.dart';
import 'package:new_buffalo_pos/utils/show_alert.dart';
import 'package:sqflite/sqflite.dart';

class SyncModel extends BaseModel {
  APIService _apiService = locator<APIService>();
  int _dataLength;
  int get dataLength => _dataLength;
  int _successCount = 0;

  syncDataToServer(SyncData data) async {
    ResponseResultData response = await _apiService.postSell(data);
    if (response.result) {
      _successCount++;
      _dataLength--;
      await deleteSyncedData(data.id);
    }
  }

  syncAll(BuildContext context) async {
    setState(ViewState.Busy);
    _successCount = 0;
    final Database _db = await DBHelper.database;
    final _dbTable = 'sale';
    final _detailTable = 'saleDetail';
    final List<Map<String, dynamic>> _dataMap = await _db.query(_dbTable);
    for (var it in _dataMap) {
      final List<Map<String, dynamic>> _dataDetailMap = await _db
          .query(_detailTable, where: 'head = ?', whereArgs: [it['id']]);
      SyncData _data = SyncData(it['id'], it['mode'],
          _dataDetailMap.map((e) => ProductDetail.fromJson(e)).toList());
      await syncDataToServer(_data);
    }
    setState(ViewState.DataFetched);
    if (_dataLength == 0)
      ShowAlert.show(context, "同步完成", "所有貨單皆上傳完畢");
    else
      ShowAlert.show(
          context, "同步結束", "成功上傳: $_successCount 筆, 失敗單數: $_dataLength");
  }

  deleteSyncedData(int id) async {
    final Database _db = await DBHelper.database;
    final _dbTable = 'sale';
    final _detailTable = 'saleDetail';
    await _db.delete(
      _dbTable,
      where: "id = ?",
      whereArgs: [id],
    );
    await _db.delete(
      _detailTable,
      where: "head = ?",
      whereArgs: [id],
    );
  }

  getDBLength() async {
    setState(ViewState.Busy);
    final Database _db = await DBHelper.database;
    final _dbTable = 'sale';
    final List<Map<String, dynamic>> _dataMap = await _db.query(_dbTable);
    _dataLength = _dataMap.length;
    setState(ViewState.DataFetched);
  }
}
