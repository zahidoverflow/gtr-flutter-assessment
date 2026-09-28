import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/services/storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  Future<UserModel> login({
    required String username,
    required String password,
    int comId = ApiConstants.defaultComId,
  }) async {
    final queryParams = {
      'UserName': username.trim(),
      'Password': password.trim(),
      'ComId': comId.toString(),
    };

    final response = await _apiClient.get(
      ApiConstants.loginEndpoint,
      queryParameters: queryParams,
    );

    if (response is Map<String, dynamic>) {
      final user = UserModel.fromJson(response);
      if (user.token.isEmpty) {
        throw ApiException('Invalid credentials or authentication failed.');
      }

      // Persist session
      await _storageService.saveToken(user.token);
      await _storageService.saveUserData(
        userName: user.userName,
        email: user.email,
        companyName: user.companyName,
        userId: user.userId,
        comId: user.comId,
      );

      return user;
    } else {
      throw ApiException('Unexpected login response format from server.');
    }
  }

  Future<void> logout() async {
    await _storageService.clearSession();
  }

  bool isAuthenticated() => _storageService.hasToken();
  String? getSavedToken() => _storageService.getToken();
}
