import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/login_view_model.dart';
import 'package:new_buffalo_pos/ui/shared/font_styles.dart';
import 'package:new_buffalo_pos/ui/views/base_view.dart';
import 'package:new_buffalo_pos/ui/views/home/home_view.dart';
import 'package:new_buffalo_pos/ui/views/widgets/busy_overlay.dart';
import 'package:new_buffalo_pos/utils/token_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginViewModel _model;
  TextEditingController _accountController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _memberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) async {
        var _checkToken = await TokenHelper().getToken();
        if (_checkToken != null) _pushToHomePage();
      },
      builder: (context, child, model) {
        _model = model;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BusyOverlay(
            show: model.state == ViewState.Busy,
            title: '登入中...',
            child: Scaffold(
              backgroundColor: Colors.red[600],
              body: _body(),
            ),
          ),
        );
      },
    );
  }

  _body() {
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[              
              SizedBox(height: 80),
              TextFormField(
                onChanged: (value) => setState(() {}),
                keyboardType: TextInputType.emailAddress,
                controller: _accountController,
                style: largeTitle,
                decoration: InputDecoration(
                  hintText: '帳號',
                  hintStyle: TextStyle(color: Colors.white60),
                  errorStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  suffixIcon: _accountController.text != ''
                      ? IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white60),
                          onPressed: () => setState(() {
                            _accountController.clear();
                          }),
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == '') {
                    return '請輸入帳號';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() {}),
                keyboardType: TextInputType.emailAddress,
                controller: _memberController,
                style: largeTitle,
                decoration: InputDecoration(
                  hintText: '會員編號',
                  hintStyle: TextStyle(color: Colors.white60),
                  errorStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  suffixIcon: _passwordController.text != ''
                      ? IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white60),
                          onPressed: () => setState(() {
                            _memberController.clear();
                          }),
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == '') {
                    return '請輸入會員編號';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) => setState(() {}),
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                controller: _passwordController,
                style: largeTitle,
                decoration: InputDecoration(
                  hintText: '密碼',
                  hintStyle: TextStyle(color: Colors.white60),
                  errorStyle:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  suffixIcon: _passwordController.text != ''
                      ? IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white60),
                          onPressed: () => setState(() {
                            _passwordController.clear();
                          }),
                        )
                      : null,
                ),
                validator: (value) {
                  if (value == '') {
                    return '請輸入密碼';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.red[900],
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(                  
                  '登入',
                  style: TextStyle(                  
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                onPressed: () => _loginPress(),
                onLongPress: () => _model.checkAuth(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loginPress() async {
    _pushToHomePage();
    // FocusScope.of(context).requestFocus(FocusNode());
    // if (_formKey.currentState.validate()) {
    //   await _model.login(_accountController.text, _passwordController.text,
    //       _memberController.text, context);
    //   if (_model.state == ViewState.DataFetched) 
    // }
  }

  // Navigation
  _pushToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}
