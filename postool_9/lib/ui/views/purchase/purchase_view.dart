import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/purchase_model.dart';
import 'package:new_buffalo_pos/ui/shared/bar_code_scan_view.dart';
import 'package:new_buffalo_pos/ui/shared/page_app_bar.dart';
import 'package:new_buffalo_pos/ui/shared/pruduct_list_tile.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';
import '../base_view.dart';

class Purchase extends StatefulWidget {
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  PurchaseModel _model;

  @override
  Widget build(BuildContext context) {
    return BaseView<PurchaseModel>(
      builder: (context, child, model) {
        _model = model;
        return Scaffold(
          appBar: PageAppBar("進貨系統"),
          body: BusyOverlay(
              show: _model.state == ViewState.Busy,
              title: '查詢中...',
              child: _buildPurchaseView()),
        );
      },
    );
  }

  Widget _buildPurchaseView() => ListView(
        children: <Widget>[
          BarCodeView("進貨 條碼 掃描", _model),
          ..._buildBodyList(),
          _confirmButton(),
        ],
      );

  List _buildBodyList() {
    List<PruductTile> _list = [];
    _model.productList.forEach((it) => _list.add(PruductTile(it)));
    return _list;
  }

  Widget _confirmButton() => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 300,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FlatButton(
            onPressed: () => _confirmOnClick(),
            child: Text(
              "確認",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      );

  _confirmOnClick() {
    _model.confirmPurchase(_model.productList, context);
  }
}
