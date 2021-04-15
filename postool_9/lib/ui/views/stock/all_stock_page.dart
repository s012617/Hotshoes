import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/stock_model.dart';
import 'package:new_buffalo_pos/ui/shared/pruduct_list_tile.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';
import '../base_view.dart';

class AllStock extends StatefulWidget {
  @override
  _AllStockState createState() => _AllStockState();
}

class _AllStockState extends State<AllStock> {
  StockModel _model;
  int _page;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _page = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StockModel>(
      onModelReady: (model) {
        model.getStock(_page, context);
        _model = model;
      },
      builder: (context, child, model) {
        return BusyOverlay(
          show: _model.state == ViewState.Busy,
          title: '查詢中...',
          child: _buildAllStockView(),
        );
      },
    );
  }

  Widget _buildAllStockView() => NotificationListener(
        onNotification: (it) {
          if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent) {
            _page++;
            _model.getStock(_page, context);
          }
        },
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            ..._allStockList(),
          ],
        ),
      );

  List _allStockList() {
    List<PruductTile> _list = [];
    _model.productList.forEach((it) => _list.add(PruductTile(it)));
    return _list;
  }
}
