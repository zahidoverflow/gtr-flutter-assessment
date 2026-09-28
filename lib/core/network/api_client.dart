import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiClient {
  final StorageService _storageService;
  final http.Client _client;

  ApiClient(this._storageService, [http.Client? client])
      : _client = client ?? http.Client();

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final token = _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = token;
    }
    return headers;
  }

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint')
          .replace(queryParameters: queryParameters);

      final response = await _client
          .get(uri, headers: _buildHeaders())
          .timeout(const Duration(seconds: 20));

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('No internet connection. Please check your network.');
    } on TimeoutException {
      throw ApiException('Connection timed out. Please try again.');
    } on FormatException {
      throw ApiException('Unable to process the server response.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else if (statusCode == 401 || statusCode == 403) {
      throw ApiException('Session expired or unauthorized. Please log in again.', statusCode);
    } else if (statusCode == 404) {
      throw ApiException('Requested resource not found.', statusCode);
    } else if (statusCode >= 500) {
      throw ApiException('Internal server error. Please try again later.', statusCode);
    } else {
      throw ApiException('Request failed with status: $statusCode', statusCode);
    }
  }
}
