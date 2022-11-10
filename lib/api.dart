
import 'dart:io';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

import 'config.dart';

class Api {

  static Future<Response> get({
    required String url, required String methodName,
    bool ignoreCertificate = false,
  }) async {
    Dio dio = Dio();
    if (ignoreCertificate) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    log(
      'Api.$methodName: send request',
      name: Config.appName,
    );

    Response response = await dio.get(
      url,
      options: Options(
        sendTimeout: Config.sendTimeout,
        responseType: ResponseType.bytes,
        receiveTimeout: Config.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    ).timeout(const Duration(milliseconds: Config.sendTimeout + Config.receiveTimeout));

    return response;
  }

  static Future<Map<dynamic, dynamic>> getHeadlines({
    required int page, required int pageSize, String? category,
  }) async {
    final Response response = await get(
      url: '${Config.apiUrl}${Config.headlines}pageSize=$pageSize&page=$page'
          '&category=${category ?? 'technology'}&${Config.apiKey}',
      methodName: 'getHeadlines',
    );

    log(
      'Api.getHeadlines: status code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data)) as Map;
  }

  static Future<Map<dynamic, dynamic>> getEverything({
    required int page, required int pageSize, String? query,
  }) async {
    final Response response = await get(
      url: '${Config.apiUrl}${Config.everything}pageSize=$pageSize&page=$page'
          '&q=${query ?? 'apple'}&${Config.apiKey}',
      methodName: 'getEverything',
    );

    log(
      'Api.getEverything: status code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data)) as Map;
  }

  static Future<Map<dynamic, dynamic>> getNewByQuery({
    required String query, String? category,
  }) async {
    final Response response = await get(
      url: '${Config.apiUrl}${Config.headlines}q=${Uri.encodeFull(query)}'
          '&category=${category ?? 'technology'}&${Config.apiKey}',
      methodName: 'getNewByQuery',
    );

    log(
      'Api.getNewByQuery: status code ${response.statusCode}',
      name: Config.appName,
    );

    return jsonDecode(utf8.decode(response.data)) as Map;
  }
}