import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/model/product.dart';
import 'package:new_buffalo_pos/model/purchase.dart';
import 'package:new_buffalo_pos/scope_model/base_model.dart';
import 'package:new_buffalo_pos/utils/db_helper.dart';
import 'package:new_buffalo_pos/utils/show_alert.dart';
import 'package:sqflite/sqflite.dart';

class SaleViewModel extends BaseModel {
  List<PurchaseData> _productList = [];
  List<PurchaseData> get productList => _productList;
  List<String> _productIdList = [];
  List<String> get productIdList => _productIdList;

  addProduct(String _code, BuildContext context) async {
    if (_code.isNotEmpty) {
      setState(ViewState.Busy);
      if (_productIdList.isEmpty || !_productIdList.contains(_code)) {
        if (!_code.contains("錯誤")) {
          _productIdList.add(_code);
          _productList.add(PurchaseData(_code, 1));
        } else
          ShowAlert.show(context, "", _code);
      } else
        _productIdList.forEach((it) {
          if (_code == it) _productList[_productIdList.indexOf(it)].quantity++;
        });
      setState(ViewState.DataFetched);
    }
  }

  deleteSlidablelistTile(int index) {
    setState(ViewState.Busy);
    _productList.removeAt(index);
    _productIdList.removeAt(index);
    setState(ViewState.DataFetched);
  }

  confirmOnTap(BuildContext context) {
    if (_productList.isNotEmpty) _insertSale();
    Navigator.pop(context);
  }

  _insertSale() async {
    final Database _db = await DBHelper.database;
    final _dbTable = 'sale';
    final _detailTable = 'saleDetail';
    String _now = DateFormat('yyyy-MM-dd-kk:mm:ss').format(DateTime.now());
    final _json = Product(_now, "1");
    int _id = await _db.insert(
      _dbTable,
      _json.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _productList.forEach((it) async {
      await _db.insert(
        _detailTable,
        {
          'barCode': it.barCode,
          'quantity': it.quantity,
          'head': _id,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
