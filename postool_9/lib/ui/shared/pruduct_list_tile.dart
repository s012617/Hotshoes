import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/model/purchase.dart';

class PruductTile extends StatelessWidget {
  final PurchaseData _product;
  const PruductTile(this._product);

  @override
  Widget build(BuildContext context) {
    return _buildPruductTile();
  }

  Widget _buildPruductTile() => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 32.0,
              right: 32.0,
              bottom: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      _product.barCode,
                      style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                _product.quantity == 0
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("x${_product.quantity.toInt()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      );
}
