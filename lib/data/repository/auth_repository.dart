import 'package:flutter/cupertino.dart';
import 'package:nike_store/common/http_client.dart';
import 'package:nike_store/data/auth_info.dart';
import 'package:nike_store/data/repository/cart_repository.dart';
import 'package:nike_store/data/repository/product_repository.dart';
import 'package:nike_store/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(String username, String password);
  Future<void> refreshToken();
}

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> register(String username, String password) async {
    final AuthInfo authInfo = await dataSource.register(username, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo =
          await dataSource.refresh(authChangeNotifier.value!.refreshToken);
      debugPrint('refresh token is: ${authInfo.refreshToken}');

      _persistAuthTokens(authInfo);
    }
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthToken();
  }

  Future<void> loadAuthToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final accessToken = sharedPreferences.getString("access_token") ?? "";
    final refreshToken = sharedPreferences.getString("refresh_token") ?? "";
    final email = sharedPreferences.getString("email") ?? "";
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken, email);
    }
  }

  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
    CartRepository.cartItemCountNotifier.value = 0;
  }
}
