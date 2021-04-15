import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/sync_model.dart';
import 'package:new_buffalo_pos/ui/views/purchase/purchase_view.dart';
import 'package:new_buffalo_pos/ui/views/puschase_return/puschase_return_view.dart';
import 'package:new_buffalo_pos/ui/views/return/return_view.dart';
import 'package:new_buffalo_pos/ui/views/sale/sale_view.dart';
import 'package:new_buffalo_pos/ui/views/stock/stock_view.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';
import 'package:new_buffalo_pos/utils/token_helper.dart';

import '../base_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SyncModel _model;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              '離開系統?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('取消',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
              FlatButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text('離開',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SyncModel>(
      onModelReady: (model) => model.getDBLength(),
      builder: (context, child, model) {
        _model = model;
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: _homeAppBar(),
            body: BusyOverlay(
              show: _model.state == ViewState.Busy,
              title: '同步中..',
              child: _buildHomeView(context),
            ),
          ),
        );
      },
    );
  }

  Widget _homeAppBar() => AppBar(
        title: Text(
          "我的系統",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 22,
          ),
        ),
        leading: FlatButton(
          child: Text(
            "登出",
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            TokenHelper().removeToken();
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color(0xffef7678),
                Color(0xffb41513),
              ],
            ),
          ),
        ),
      );

  Widget _buildHomeView(BuildContext context) => GridView.count(
        padding: EdgeInsets.only(top: 30),
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 2,
        children: <Widget>[
          _menuButton(1, context),
          _menuButton(2, context),
          _menuButton(3, context),
          _menuButton(4, context),
          // _menuButton(5, context),
          _menuButton(6, context),
        ],
      );

  Widget _menuButton(int index, BuildContext context) => Stack(
        children: <Widget>[
          _menuTile(index, context),
          index == 6 && _model.dataLength != 0 && _model.dataLength != null
              ? _redDot()
              : Container(),
        ],
      );

  Widget _menuTile(int index, BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 16.0,
        ),
        child: InkWell(
          onTap: () => _menuClickJudge(index, context),
          child: index == 1
              ? Image(
                  image: AssetImage('assets/images/purchase.png'),
                )
              : index == 2
                  ? Image(image: AssetImage('assets/images/sale.png'))
                  : index == 3
                      ? Image(image: AssetImage('assets/images/stock.png'))
                      : index == 4
                          ? Image(image: AssetImage('assets/images/return.png'))
                          : index == 5
                              ? Image(
                                  image: AssetImage(
                                      'assets/images/purchase_return.png'))
                              : Image(
                                  image: AssetImage('assets/images/sync.png')),
        ),
      );

  Widget _redDot() => Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            height: 35,
            width: 35,
            child: Center(
              child: Text(
                _model.dataLength.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );

  _menuClickJudge(int index, BuildContext context) async {
    switch (index) {
      case 1:
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Purchase()));
        _model.getDBLength();
        break;
      case 2:
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Sale()));
        _model.getDBLength();
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Stock()));
        break;
      case 4:
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Return()));
        _model.getDBLength();
        break;
      case 5:
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => PurchaseReturn()));
        _model.getDBLength();
        break;
      case 6:
        _model.syncAll(context);
        break;
    }
  }
}
