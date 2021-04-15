import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/model/purchase.dart';
import 'package:new_buffalo_pos/scope_model/stock_model.dart';
import 'package:new_buffalo_pos/ui/shared/bar_code_scan_view.dart';
import 'package:new_buffalo_pos/ui/shared/pruduct_list_tile.dart';
import 'package:new_buffalo_pos/ui/views/stock/stock_tile.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';
import 'package:new_buffalo_pos/utils/barcode_scanner.dart';
import '../base_view.dart';

class SingleStock extends StatefulWidget {
  @override
  _SingleStockState createState() => _SingleStockState();
}

class _SingleStockState extends State<SingleStock> {
  StockModel _model;

  @override
  Widget build(BuildContext context) {
    return BaseView<StockModel>(
      builder: (context, child, model) {
        _model = model;
        return BusyOverlay(
          show: _model.state == ViewState.Busy,
          title: '查詢中...',
          child: _buildSingleStockView(),
        );
      },
    );
  }

  Widget _buildSingleStockView() => ListView(
        children: <Widget>[
          BarCodeView("庫存 條碼 掃描", _model),
          PruductTile(PurchaseData(_model.barCode, 0)),
          ..._buildBodyList(),
        ],
      );

  List _buildBodyList() {
    List<StockTile> _list = [];
    _model.stockList.forEach((it) => _list.add(StockTile(it)));
    return _list;
  }
}
