import 'dart:convert';

import 'package:new_buffalo_pos/config.dart';
import 'package:new_buffalo_pos/model/sync.dart';
import 'package:new_buffalo_pos/utils/http_helper.dart';

class APIService {
  Future<ResponseResultData> login(
      String account, String password, String empId) async {
    final String url = baseUrl('/login');

    var bytes = utf8.encode('$account:$password:$empId');
    var loginStr = base64Encode(bytes);
    var headers = {'Authorization': 'Basic $loginStr'};
    var response =
        await HttpHelper.doCustom(url, null, false, 'GET', headers: headers);
    return response;
  }

  Future<ResponseResultData> getStockById(String shipId) async {
    final String url = baseUrl('/stock');

    var query = {'shipId': shipId};
    var response = await HttpHelper.doGet(url, true, queryParam: query);
    return response;
  }

  Future<ResponseResultData> confirmStock(String shipId, List<Map> json) async {
    final String url = baseUrl('/stock/confirm');
    var _body = {'shipId': shipId, 'data': json};
    print(_body);
    var response = await HttpHelper.doPost(url, _body, true);
    return response;
  }

  Future<ResponseResultData> needAuth() async {
    final String url = baseUrl('/needauth');
    var response = await HttpHelper.doGet(url, true);
    return response;
  }

  Future<ResponseResultData> getGoodStorage(int page) async {
    final String url = baseUrl('/goodstorage');
    var query = {'page': page};
    var response = await HttpHelper.doGet(url, true, queryParam: query);
    return response;
  }

  Future<ResponseResultData> getGoodStorageByCode(String barCode) async {
    final String url = baseUrl('/goodstorage/bar');
    var query = {'barCode': barCode};
    var response = await HttpHelper.doGet(url, true, queryParam: query);
    return response;
  }

  Future<ResponseResultData> postSell(SyncData data) async {
    final String url = baseUrl('/sell');
      var _body = data.toJson();
      var response = await HttpHelper.doPost(url, _body, true);
      print(response.data);
      return response;
  }
}
