import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:new_buffalo_pos/service_locator.dart';
import 'package:new_buffalo_pos/utils/token_helper.dart';

class HttpHelper {
  static const _GET = "GET";
  static const _POST = "POST";
  static const _PUT = "PUT";

  static doGet(url, bool needToken, {Map<String, dynamic> queryParam}) async {
    return await _doRequest(url, null, new Options(method: _GET), needToken,
        queryParam: queryParam);
  }

  static doPost(url, params, bool needToken) async {
    return await _doRequest(url, params, new Options(method: _POST), needToken);
  }

  static doPut(url, params, bool needToken,
      {Map<String, dynamic> queryParam}) async {
    return await _doRequest(url, params, new Options(method: _PUT), needToken,
        queryParam: queryParam);
  }

  static doCustom(url, params, bool needToken, String method,
      {Map<String, dynamic> queryParam, Map<String, dynamic> headers}) async {
    ResponseResultData response = await _doRequest(
        url, params, Options(method: method, headers: headers), needToken,
        queryParam: queryParam);
    return response;
  }

  static _doRequest(url, params, Options options, bool needToken,
      {Map<String, dynamic> queryParam}) async {
    // Check network available
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResponseResultData(null, false, -1);
    }

    Map<String, dynamic> headers = await _getHeaders(needToken);
    if (headers == null) 
    ResponseResultData(null, false, 401); // Unauthorized

    Map<String, dynamic> cusotomHeaders = options.headers;
    if (options != null) {
      options.headers = headers;
    } else {
      options = new Options(method: _GET);
      options.headers = headers;
    }
    options.headers.addAll(cusotomHeaders);

    options.sendTimeout = 15 * 1000;

    Dio _dio = new Dio();
    try {
      Response response;
      response = await _dio.request(url,
          data: params, queryParameters: queryParam, options: options);
      return new ResponseResultData(response.data, true, response.statusCode);
    } on DioError catch (e) {
      return new ResponseResultData(
          e.response.data, false, e.response.statusCode);
    } catch (e) {
      print('request error is $e');
      return new ResponseResultData(null, false, -2);
    }
  }

  static _getHeaders(bool needToken) async {
    Map<String, dynamic> headers = {};
    if (needToken) {
      var token = await locator<TokenHelper>().getToken();
      if (token != null)
        headers["Authorization"] = 'Bearer ' + token;
      else
        return null;
    }
    return headers;
  }
}

class ResponseResultData {
  var data;
  bool result;
  int code;

  ResponseResultData(this.data, this.result, this.code);
}
