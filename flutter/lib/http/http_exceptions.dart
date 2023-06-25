import 'package:dio/dio.dart';

/// 自定义异常
class DioHttpException implements Exception {
  final String? message;
  final int? code;

  DioHttpException([
    this.code,
    this.message,
  ]);

  String toString() {
    return "$code$message";
  }

  factory DioHttpException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.other:
        {
          // 网络异常
          return BadRequestException(-2, "无网络");
        }

      case DioErrorType.cancel:
        {
          return BadRequestException(-1, "请求取消");
        }

      case DioErrorType.connectTimeout:
        {
          return BadRequestException(-1, "连接超时");
        }

      case DioErrorType.sendTimeout:
        {
          return BadRequestException(-1, "请求超时");
        }

      case DioErrorType.receiveTimeout:
        {
          return BadRequestException(-1, "响应超时");
        }

      case DioErrorType.response:
        {
          try {
            int? errCode = error.response!.statusCode;
            switch (errCode) {
              case 400:
                {
                  String? msgOf400;
                  try {
                    msgOf400 = error.response!.data["message"];
                  } on Exception catch (e) {
                    print('****** 400 exception: $e');
                  }
                  return BadRequestException(errCode, msgOf400 ?? "请求语法错误");
                }

              case 401:
                {
                  return UnauthorisedException(errCode, "没有权限");
                }

              case 403:
                {
                  return UnauthorisedException(errCode, "服务器拒绝执行");
                }

              case 404:
                {
                  return UnauthorisedException(errCode, "无法连接服务器");
                }

              case 405:
                {
                  return UnauthorisedException(errCode, "请求方法被禁止");
                }

              case 500:
                {
                  return UnauthorisedException(
                      errCode, error.response?.statusMessage ?? "服务器内部错误");
                }

              case 502:
                {
                  return UnauthorisedException(errCode, "无效的请求");
                }

              case 503:
                {
                  return UnauthorisedException(errCode, "服务器挂了");
                }

              case 505:
                {
                  return UnauthorisedException(errCode, "不支持HTTP协议请求");
                }

              default:
                {
                  return DioHttpException(
                      errCode, error.response?.statusMessage);
                }
            }
          } on Exception catch (_) {
            return DioHttpException(-1, "未知错误");
          }
        }
        break;

      default:
        {
          return DioHttpException(-1, error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends DioHttpException {
  BadRequestException([int? code, String? message]) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends DioHttpException {
  UnauthorisedException([int? code, String? message]) : super(code, message);
}
