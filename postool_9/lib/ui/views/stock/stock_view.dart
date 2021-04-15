import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/stock_model.dart';
import 'package:new_buffalo_pos/ui/shared/page_app_bar.dart';
import 'package:new_buffalo_pos/ui/views/stock/all_stock_page.dart';
import 'package:new_buffalo_pos/ui/views/stock/single_stock_page.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';

import '../base_view.dart';

class Stock extends StatefulWidget {
  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<StockModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: PageAppBar("庫存查詢"),
        body: _buildStockView(),
      );
    });
  }

  Widget _buildStockView() => Column(
        children: <Widget>[
          _tabBar(),
          _tabView(),
        ],
      );

  Widget _tabBar() => Container(
        margin: const EdgeInsets.only(
          top: 48.0,
          right: 36.0,
          left: 36.0,
        ),
        decoration: BoxDecoration(
         
          color: Colors.white,
        ),
        height: 70,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(              
              color: Colors.grey),
          tabs: <Widget>[
            Tab(
              text: "全部庫存",
            ),
            Tab(
              text: "單一庫存",
            ),
          ],
        ),
      );

  Widget _tabView() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              AllStock(),
              SingleStock(),
            ],
          ),
        ),
      );
}
