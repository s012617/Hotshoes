import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class BarCodeScanner {
  Future<String> barCodeScan() async {
    String _barcode = "";

    try {
      ScanResult _scanResult = await BarcodeScanner.scan();
      String _getBarcode = _scanResult.rawContent;
      _barcode = _getBarcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _barcode = '錯誤: 獲取相機權限失敗';
      } else {
        _barcode = '錯誤: $e';
      }
    } on FormatException {
      _barcode = null;
    } catch (e) {
      _barcode = '錯誤: $e';
    }
    return _barcode;
  }
}
