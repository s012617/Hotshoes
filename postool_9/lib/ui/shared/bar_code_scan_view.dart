import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_buffalo_pos/utils/barcode_scanner.dart';

class BarCodeView extends StatefulWidget {
  final String _title;
  final _model;
  const BarCodeView(this._title, this._model);

  @override
  _BarCodeViewState createState() => _BarCodeViewState();
}

class _BarCodeViewState extends State<BarCodeView> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _textEditingController.addListener(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 48.0,
        right: 36.0,
        left: 36.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                autofocus: true,
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                onEditingComplete: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                keyboardType: TextInputType.url,
                focusNode: _focusNode,
                cursorColor: Colors.pink[200],
                decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(letterSpacing: 2, color: Colors.black26),
                  hintText: widget._title,
                ),
                onSubmitted: (value) async {
                  if (value.isNotEmpty)
                    await widget._model.addProduct(value, context);
                  _textEditingController.clear();
                  FocusScope.of(context).requestFocus(_focusNode);
                },
              ),
            ),
            InkWell(
              onTap: () => _cameraOnTap(context),
              child: Image.asset(
                'assets/images/camera.png',
                fit: BoxFit.cover,
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cameraOnTap(BuildContext context) async {
    String _code = await BarCodeScanner().barCodeScan();
    if (_code != null) await widget._model.addProduct(_code, context);
  }
}
