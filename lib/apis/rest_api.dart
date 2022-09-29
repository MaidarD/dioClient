import 'package:dio_test/apis/rest_api_client.dart';

class RestApi {
  static final RestApi _singleton = RestApi._internal();

  factory RestApi() => _singleton;

  RestApi._internal();

  final RestApiClient _restApiClient = RestApiClient();

  /// Auth Api
  Future<CustomResponse> login(dynamic body) async {
    return _restApiClient.sendRequest('auth/login', Method.post, body: body);
  }

  Future<CustomResponse> signUp(dynamic body) async {
    return _restApiClient.sendRequest('auth/signup', Method.post, body: body);
  }

  /// User Api
  Future<CustomResponse> userMe() async {
    return _restApiClient.sendRequest('user/me', Method.get);
  }

  /// Device Api
  Future<CustomResponse> getDevice() async {
    return _restApiClient.sendRequest('device', Method.get);
  }

  Future<CustomResponse> getDeviceUserHome() async {
    return _restApiClient.sendRequest('device/user_home', Method.get);
  }

  Future<CustomResponse> getProductCategory() async {
    return _restApiClient.sendRequest('product/category', Method.get);
  }

  Future<CustomResponse> getProductList({required String product}) async {
    return _restApiClient.sendRequest('$product/list', Method.get);
  }

  Future<CustomResponse> getProductDetails({
    required String product,
    required String serialNumber,
  }) async {
    return _restApiClient.sendRequest('$product/detail?serial_number=$serialNumber', Method.get);
  }
}
