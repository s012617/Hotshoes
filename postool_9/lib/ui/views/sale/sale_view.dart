import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_buffalo_pos/model/purchase.dart';
import 'package:new_buffalo_pos/scope_model/sale_model.dart';
import 'package:new_buffalo_pos/ui/shared/bar_code_scan_view.dart';
import 'package:new_buffalo_pos/ui/shared/page_app_bar.dart';
import 'package:new_buffalo_pos/ui/shared/pruduct_list_tile.dart';
import 'package:new_buffalo_pos/ui/views/base_view.dart';

class Sale extends StatefulWidget {
  @override
  _SaleState createState() => _SaleState();
}

class _SaleState extends State<Sale> {
  SaleViewModel _model;

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SaleViewModel>(
      builder: (context, child, model) {
        _model = model;
        return Scaffold(
          appBar: PageAppBar("銷貨系統"),
          body: _buildSaleView(context),
        );
      },
    );
  }

  Widget _buildSaleView(BuildContext context) => ListView(
        children: <Widget>[
          BarCodeView("銷貨 條碼 掃描", _model),
          ..._buildBodyList(),
          _confirmButton(context),
        ],
      );

  List _buildBodyList() {
    List _list = _model.productList
        .map((e) => _slidableListTile(e, _model.productList.indexOf(e)))
        .toList();
    return _list;
  }

  Widget _slidableListTile(PurchaseData data, int index) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        secondaryActions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: IconSlideAction(
              caption: '刪除',
              color: Colors.red,
              icon: Icons.delete_outline,
              onTap: () => _model.deleteSlidablelistTile(index),
            ),
          ),
        ],
        child: PruductTile(data),
      );

  Widget _confirmButton(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          width: 300,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.greenAccent[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: FlatButton(
            onPressed: () => _model.confirmOnTap(context),
            child: Text(
              "結帳確認",
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
}
