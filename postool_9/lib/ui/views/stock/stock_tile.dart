import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/model/stock.dart';

class StockTile extends StatelessWidget {
  final StockData _stock;
  const StockTile(this._stock);

  @override
  Widget build(BuildContext context) {
    return _buildStockTile();
  }

  Widget _buildStockTile() => Container(
    color: _stock.quantity == 0 ? Colors.red[100] : Colors.transparent,
    child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 32.0,
                right: 32.0,
                bottom: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _stock.sizeName,
                    style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32.0,
                      top: 8.0,
                    ),
                    child: Text(
                      'x${_stock.quantity.toInt()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
  );
}
