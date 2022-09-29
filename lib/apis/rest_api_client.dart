import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:connectivity_plus/connectivity_plus.dart';

///RestAPI хүсэлт дуудах method-ууд
enum Method { get, post, put, delete }

class RestApiClient {
  static final RestApiClient _singleton = RestApiClient._internal();

  factory RestApiClient() => _singleton;

  RestApiClient._internal();

  static late String _baseUrl;

  static init({
    required String baseUrl,
  }) {
    _baseUrl = baseUrl;
  }

  static String getBaseUrl() => _baseUrl;

  dio.Dio? _dio;

  String _getMethodName(Method method) {
    switch (method) {
      case Method.delete:
        return 'DELETE';
      case Method.put:
        return 'PUT';
      case Method.get:
        return 'GET';
      case Method.post:
        return 'POST';
    }
  }

  Future<CustomResponse> sendRequest(
    String path,
    Method method, {
    dynamic body,
    Map<String, dynamic>? queryParam,
  }) async {
    bool hasInternet =
        await _isConnectedToNetwork(checkServerConnection: false);

    if (!hasInternet) {
      return CustomResponse(
        data: {},
        success: false,
        error: {
          'code': 404,
          'message': 'no_internet'.tr,
        },
      );
    }

    try {
      String methodName = _getMethodName(method);
      var client = _getApiClient();
      var options = dio.Options(method: methodName);
      var url = _formatUrl(path);

      dio.Response response = await client.request(url,
          queryParameters: queryParam,
          // data: (isMultiPart ?? false) ? body : _requestBody,
          data: body,
          options: options);

      return CustomResponse(
        data: response.data['data'] ?? {},
        error: response.data['success'] == true
            ? null
            : response.data['error'] ?? '',
        success: response.data['success'] == true,
      );
    } catch (e) {
      if (e is dio.DioError) {
        return CustomResponse(
          data: {},
          success: false,
          error: {
            'code': 1997,
            'message': e.message.toString(),
          },
        );
      } else {
        return CustomResponse(
          data: {},
          success: false,
          error: {
            'code': 1997,
            'message': e.toString(),
          },
        );
      }
    }
  }

  String _formatUrl(String url) {
    if ((url).isEmpty) return '';
    String editedUrl =
        url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return Uri.encodeFull(editedUrl);
  }

  dio.Dio _getApiClient() {
    assert((getBaseUrl()).isNotEmpty);
    if (_dio == null) {
      _dio = dio.Dio();

      _dio?.options.connectTimeout = 30 * 1000;
      _dio?.options.receiveTimeout = 30 * 1000;
      (_dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    _dio?.options.baseUrl = getBaseUrl();
    // String? _tokenType = RestApiHelper.getTokenType();
    // String? _token = RestApiHelper.getToken();

    Map<String, dynamic> reqHeader = {};
    // _reqHeader['X_CLIENT_VERSION'] = _appVersion;

    // String accessToken = RestApiHelper.getAccessToken();
    // if (accessToken.isNotEmpty) {
    //   reqHeader['Authorization'] = 'Bearer $accessToken';
    // }

    _dio?.options.headers = reqHeader;
    _dio?.options.contentType = 'application/json';

    return _dio!;
  }

  Future<bool> _isConnectedToNetwork({
    String? url,
    bool checkServerConnection = false,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return checkServerConnection
          ? await _isConnectedToServer(url ?? 'google.com')
          : true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return checkServerConnection
          ? await _isConnectedToServer(url ?? 'google.com')
          : true;
    }
    return false;
  }

  Future<bool> _isConnectedToServer(String url) async {
    try {
      final result = await InternetAddress.lookup(url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}

class CustomResponse {
  final bool success;
  final dynamic data;
  final dynamic error;

  CustomResponse({
    this.data,
    required this.error,
    required this.success,
  });
}
