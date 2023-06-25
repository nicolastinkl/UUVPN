import 'package:dio/dio.dart';
import 'http.dart';
import 'package:sync_http/sync_http.dart';

class HttpUtils {
  static void init(
      {String? baseUrl,
      int? connectTimeout,
      int? receiveTimeout,
      List<Interceptor>? interceptors}) {
    Http().init(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        interceptors: interceptors);
  }

  static void setHeaders(Map<String, dynamic> map) {
    Http().setHeaders(map);
  }

  static void cancelRequests({CancelToken? token}) {
    Http().cancelRequests(token: token);
  }

  static Future get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool refresh = false,
    String? cacheKey,
    bool cacheDisk = false,
    bool withoutToken = false,
  }) async {
    // SyncHttpClient.getUrl(path)
    return await Http().get(path,
        params: params,
        options: options,
        cancelToken: cancelToken,
        refresh: refresh,
        cacheKey: cacheKey,
        withoutToken: withoutToken);
  }

  static Future post(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().post(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().put(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().patch(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().delete(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future postForm(
    String path, {
    required Map<String, dynamic> data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().postForm(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
