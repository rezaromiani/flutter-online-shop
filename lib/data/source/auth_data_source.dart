import 'package:dio/dio.dart';
import 'package:nike_store/common/constants.dart';
import 'package:nike_store/common/http_response_validator.dart';
import 'package:nike_store/data/auth_info.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> register(String username, String password);
  Future<AuthInfo> refresh(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "password",
      "client_id": Constants.clientId,
      "client_secret": Constants.clientSecret,
      "username": username,
      "password": password
    });
    validateResponse(response);
    return AuthInfo(response.data["access_token"],
        response.data["refresh_token"], username);
  }

  @override
  Future<AuthInfo> refresh(String token) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": Constants.clientId,
      "client_secret": Constants.clientSecret,
    });
    validateResponse(response);
    return AuthInfo(
        response.data["access_token"], response.data["refresh_token"], "");
  }

  @override
  Future<AuthInfo> register(String username, String password) async {
    final response = await httpClient
        .post("user/register", data: {"email": username, "password": password});
    validateResponse(response);
    return login(username, password);
  }
}
