import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sail/common/public.dart';
import 'error_interceptor.dart';

class Http {
  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;

  static Http _instance = Http._internal();

  factory Http() => _instance;

  Dio? dio;
  CancelToken _cancelToken = new CancelToken();

  Http._internal() {
    if (dio == null) {
      // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
      BaseOptions options = new BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        // 响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: RECEIVE_TIMEOUT,
        headers: {},
      );
      if (options.contentType != null &&
          options.headers.containsKey(Headers.contentTypeHeader)) {
        options.headers.remove(Headers.contentTypeHeader);
      }
      dio = new Dio(options);

      // 添加拦截器
      dio!.interceptors.add(ErrorInterceptor());
      dio!.interceptors.add(LogInterceptor());
    }
  }

  /// 读取本地配置
  Future<Map<String, dynamic>?> getAuthorizationHeader() async {
    var headers;
    String? accessToken = SpUtil.getString("SP_TOKEN", defValue: null);
    if (accessToken != null) {
      int expiresM = SpUtil.getInt("SP_EXPIRES_M");
      // token过期(有5分钟缓冲时间)，刷新token
      if (DateTime.now().millisecondsSinceEpoch > expiresM) {
        // accessToken = await Auth.refreshToken();
      }
      headers = {"Authorization": 'Bearer $accessToken'};
    }
    return headers;
  }

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init(
      {String? baseUrl,
      int? connectTimeout,
      int? receiveTimeout,
      List<Interceptor>? interceptors}) {
    dio!.options = dio!.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio!.interceptors.addAll(interceptors);
    }
  }

  /// 设置headers
  void setHeaders(Map<String, dynamic> map) {
    dio!.options.headers.addAll(map);
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }

  /// restful get 操作
  Future get(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool refresh = false,
    String? cacheKey,
    bool cacheDisk = false,
    bool withoutToken = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.copyWith(extra: {
      "refresh": refresh,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    Map<String, dynamic>? _authorization = await getAuthorizationHeader();
    Map<String, dynamic>? headers = requestOptions.headers;
    if (_authorization != null &&
        (headers == null || headers["Authorization"] == null) &&
        !withoutToken) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    Response response;
    response = await dio!.get(path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post 操作
  Future post(
    String path, {
    Map<String, dynamic>? params,
    data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    if (requestOptions.headers == null ||
        requestOptions.headers!["Authorization"] == null) {
      Map<String, dynamic>? _authorization = await getAuthorizationHeader();
      if (_authorization != null) {
        requestOptions = requestOptions.copyWith(headers: _authorization);
      }
    }
    var response = await dio!.post(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful put 操作
  Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = await getAuthorizationHeader();
    if (_authorization != null &&
        (requestOptions.headers == null ||
            requestOptions.headers!["Authorization"] == null)) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio!.put(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful patch 操作
  Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic>? _authorization = await getAuthorizationHeader();
    if (_authorization != null &&
        (requestOptions.headers == null ||
            requestOptions.headers!["Authorization"] == null)) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio!.patch(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();

    Map<String, dynamic>? _authorization = await getAuthorizationHeader();
    if (_authorization != null &&
        (requestOptions.headers == null ||
            requestOptions.headers!["Authorization"] == null)) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio!.delete(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    required Map<String, dynamic> data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Map<String, dynamic>? _authorization = await getAuthorizationHeader();
    if (_authorization != null &&
        (requestOptions.headers == null ||
            requestOptions.headers!["Authorization"] == null)) {
      requestOptions = requestOptions.copyWith(headers: _authorization);
    }
    var response = await dio!.post(path,
        data: FormData.fromMap(data),
        queryParameters: data,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);
    return response.data;
  }
}
