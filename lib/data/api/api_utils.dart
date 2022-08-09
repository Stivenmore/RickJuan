import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:rickmorty/data/services/result.dart';

const String kAuthorizationHeader = 'Authorization';
const String kBearer = 'Bearer';

enum Method {
  delete,
  get,
  getDio,
  patch,
  post,
  put,
}

/// Api helper for make calls to the [Dio] client
///
/// Remember that you can return a mock file of set a temporal url for a custom
/// branch that is not already deployed of merged in release. See [makeRequest]
/// for more info.
class ApiUtils {
  final Dio _client;
  final String _host;
  final String? _mockfile;
  ApiUtils({
    required Dio client,
    required String host,
    String? mockfile,
  })  : _client = client,
        _host = host,
        _mockfile = mockfile;

  /// If the backend is no already implement you can use [temporalHost] for make
  /// the request to a custom endpoint something like:
  /// _**myBranch/my/endpoint/**_ Remember don't use [https://] or similar the
  /// client already make this additions in the initialization and the route
  /// must be raw.
  ///
  /// In the other way if you need return a mock file you can specific the path
  /// with [mockResponseFile] and later of 2 seconds this will be return a
  /// response with the mock response.
  ///
  /// The mock files are loaded from `assets/mocks/` something like:
  /// _**assets/mocks/yourAwesomeMock.json**_
  Future<Result<dynamic, BackendError>> makeRequest({
    dynamic data,
    String? errorPath,
    String? errorDescriptionPath,
    Map<String, dynamic>? headers,
    required Method method,
    int? mockResponseFile,
    required String path,
    Map<String, dynamic>? queryParameters,
    bool onlyPath = false,

    /// Use only if need inject a temporal host with a custom deployment branch
    String? temporalHost,
  }) async {
    /// Return a mock response if the file is specified
    if (mockResponseFile != null && mockResponseFile == 1) {
      final response = await _getMockResponse(_mockfile!);
      return Result.success(response);
    } else if (mockResponseFile != null && mockResponseFile == 2) {
      return Result.fail(
        const BackendError(
          statusCode: 500,
          description: 'default',
          err: 'default',
        ),
      );
    } else if (mockResponseFile != null && mockResponseFile == 3) {
      return Result.fail(
        const BackendError(
          statusCode: 500,
          description: 'default',
          err: 'default',
        ),
      );
    }else if (mockResponseFile != null && mockResponseFile < 1 ){
      return Result.fail(
        const BackendError(
          statusCode: 500,
          description: 'receiveTimeout',
          err: 'receiveTimeout',
        ),
      );
    }

    Map<String, dynamic> _headers = <String, dynamic>{};

    Uri uri = Uri.https(temporalHost ?? _host, path, queryParameters);

    if (onlyPath) {
      path = 'https://${temporalHost ?? _host}/$path';
    }

    final Response response;

    final Options options = Options(
      headers: _headers,
    );

    try {
      switch (method) {
        case Method.delete:
          response = await _client.deleteUri(
            uri,
            options: options,
          );
          break;
        case Method.get:
          response = await _client.getUri(
            uri,
            options: options,
          );
          break;
        case Method.getDio:
          response = await _client.get(
            path,
            options: options,
          );
          break;
        case Method.patch:
          response = await _client.patchUri(
            uri,
            data: data,
            options: options,
          );
          break;
        case Method.post:
          response = await _client.postUri(
            uri,
            data: data,
            options: options,
          );
          break;
        case Method.put:
          response = await _client.putUri(
            uri,
            data: data,
            options: options,
          );
          break;
      }
      return Result.success(response.data);
    } on DioError catch (error) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
          return Result.fail(
            BackendError(
              statusCode: error.response?.statusCode ?? 500,
              description: error.message,
              err: 'connectTimeout',
            ),
          );
        case DioErrorType.receiveTimeout:
          return Result.fail(
            BackendError(
              statusCode: error.response?.statusCode ?? 500,
              description: error.message,
              err: 'receiveTimeout',
            ),
          );
        case DioErrorType.sendTimeout:
          return Result.fail(
            BackendError(
              statusCode: error.response?.statusCode ?? 500,
              description: error.message,
              err: 'sendTimeout',
            ),
          );
        default:
          return Result.fail(
            BackendError(
              statusCode: error.response?.statusCode ?? 500,
              description: error.message,
              err: 'default',
            ),
          );
      }
    }
  }

  Future<Map<String, dynamic>> _getMockResponse(String filePath) =>
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          final file = await rootBundle.loadString('assets/mock/$filePath');
          return jsonDecode(file);
        },
      );
}