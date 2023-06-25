import 'http_exceptions.dart';

class ApiResponse<T> implements Exception {
  Status status;
  T? data;
  DioHttpException? exception;

  /**
   * 成功 网络请求
   */
  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  /**
   * 错误 网络请求
   */
  ApiResponse.error(this.exception) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $exception \n Data : $data";
  }
}

enum Status { COMPLETED, ERROR }
