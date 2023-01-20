library w_api;

import 'dart:convert';

import 'package:dio/dio.dart';

typedef Record = Map<String, dynamic>;

class WApiException {
  WApiException({
    required this.message,
    this.details,
    this.stacktrace,
    this.type,
  });

  /// A human-readable error message, possibly null.
  final String message;
  final dynamic details;
  final String? stacktrace;
  final String? type;

  @override
  String toString() => message;
}

class WApi {
  static String get get => 'get';
  static String get post => 'post';
  static String get put => 'put';
  static String get delete => 'delete';
  static String _baseUrl = '';
  static String _serverErrorMessage =
      'The system is in maintenance. Please come back in a few minutes. Sorry about the inconvenience!';

  static void init({
    String? baseUrl,
    String? serverErrorMessage,
  }) {
    if (baseUrl != null) {
      _baseUrl = baseUrl;
    }
    if (serverErrorMessage != null) {
      _serverErrorMessage = _serverErrorMessage;
    }
  }

  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static String getBaseUrl() {
    return _baseUrl;
  }

  static Future<dynamic> request(
    String method,
    String endpoint, {
    Record? query,
    Record? body,
    Options? options,
  }) async {
    final _baseOptions = BaseOptions(
      sendTimeout: 100 * 1000,
      receiveTimeout: 30 * 1000,
      baseUrl: _baseUrl,
      headers: {},
    );

    final _options = options == null ? Options() : options;
    if (_options.method == null || _options.method == '') {
      _options.method = method;
    }

    Dio dio = Dio(_baseOptions);
    try {
      final response = await dio.request(
        endpoint,
        data: body,
        queryParameters: query,
        options: options,
      );
      dynamic data = {};
      dynamic remoteData = response.data ?? {};
      if (remoteData is String) {
        try {
          remoteData = json.decode(remoteData);
        } catch (err) {
          print('''WApi request: failed to perform json.decode.
              details: method=${method}, endpoint=${endpoint}, query=${query.toString()}, body=${body.toString()}.
              error: ${err.toString()}''');
        }
      }

      if (remoteData['status'] == -1) {
        final msg = remoteData['msg'] ?? 'Unknown error';
        throw WApiException(message: msg);
      }

      if (remoteData['data'] != null) {
        data = remoteData['data'];
      }

      return data;
    } on DioError catch (err) {
      final message = err.message;
      if (message.contains('OS Error: Connection refused')) {
        throw WApiException(
          type: 'system_error',
          message: _serverErrorMessage,
          stacktrace: err.stackTrace.toString(),
          details: err.message,
        );
      }
    } catch (err) {
      if (err is WApiException) {
        rethrow;
      }
      throw WApiException(
        message: err.toString(),
        details:
            'WApi request: method=${method}, endpoint=${endpoint}, query=${query.toString()}, body=${body.toString()}',
      );
    }
  }
}
