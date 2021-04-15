import 'package:flutter/material.dart';
import 'package:new_buffalo_pos/enums/view_state.dart';
import 'package:new_buffalo_pos/scope_model/base_model.dart';
import 'package:new_buffalo_pos/service_locator.dart';
import 'package:new_buffalo_pos/services/api_service.dart';
import 'package:new_buffalo_pos/utils/http_helper.dart';
import 'package:new_buffalo_pos/utils/show_alert.dart';
import 'package:new_buffalo_pos/utils/token_helper.dart';

class LoginViewModel extends BaseModel {
  APIService _apiService = locator<APIService>();
  TokenHelper _tokenHelper = locator<TokenHelper>();

  login(String account, String password, String empId,
      BuildContext context) async {
    setState(ViewState.Busy);
    ResponseResultData response =
        await _apiService.login(account, password, empId);
    if (response.result) {
      _tokenHelper.updateToken(response.data['token']);
      setState(ViewState.DataFetched);
    } else {
      ShowAlert.show(context, "錯誤", response.data["errorMessage"] ?? "登入失敗");
      setState(ViewState.Error);
    }
  }

  checkAuth() async {
    ResponseResultData response = await _apiService.needAuth();
    if (response.result) print(response.data['token']);
    print(response.code);
  }
}
