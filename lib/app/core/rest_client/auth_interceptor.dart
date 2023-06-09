import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/exceptions/expire_token_exception.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/global/global_context.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/keys/keys.dart';
import 'package:vakinha_burger_provider_com_bloc/app/core/rest_client/custom_dio.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;
  AuthInterceptor(this.dio);
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString(Keys.accessToken);
    options.headers['Authorization'] = 'Bearer $accessToken';

    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != '/auth/refresh') {
          await _refreshToken(err);
          await _retryRequest(err, handler);
        } else {
          GlobalContext.i.loginExpire();
        }
      } catch (e) {
        GlobalContext.i.loginExpire();
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _refreshToken(DioError err) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final refreshToken = sp.getString(Keys.refreshToken);

      if (refreshToken == null) {
        return;
      }
      final resultRefresh = await dio.auth().put('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      sp.setString(Keys.accessToken, resultRefresh.data['access_token']);
      sp.setString(Keys.refreshToken, resultRefresh.data['refresh_token']);
    } on DioError catch (e, s) {
      log('Erro ao realizar refresh token', error: e, stackTrace: s);
      throw ExpireTokenException();
    }
  }

  Future<void> _retryRequest(
      DioError err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final result = await dio.request(
      requestOptions.path,
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method,
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
    handler.resolve(
      Response(
        requestOptions: requestOptions,
        data: result.data,
        statusCode: result.statusCode,
        statusMessage: result.statusMessage,
      ),
    );
  }
}
