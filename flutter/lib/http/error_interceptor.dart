import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'http_exceptions.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  Duration durationTime = Duration(seconds: 2);

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    // error统一处理
    DioHttpException appException = DioHttpException.create(err);
    // 错误提示
    print('DioError===: ${appException.toString()}');
    // err.error = appException;

    super.onError(err, handler);
  }
}
