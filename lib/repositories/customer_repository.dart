import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/customer_model.dart';

class CustomerPaginationResult {
  final List<CustomerModel> customers;
  final bool hasMore;

  CustomerPaginationResult({
    required this.customers,
    required this.hasMore,
  });
}

class CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepository(this._apiClient);

  Future<CustomerPaginationResult> getCustomers({
    int pageNo = 1,
    int pageSize = ApiConstants.defaultPageSize,
    String sortBy = ApiConstants.defaultSortBy,
    String searchQuery = '',
  }) async {
    final queryParams = {
      'pageNo': pageNo.toString(),
      'pageSize': pageSize.toString(),
      'SortyBy': sortBy,
    };

    if (searchQuery.isNotEmpty) {
      queryParams['searchquery'] = searchQuery.trim();
    }

    final response = await _apiClient.get(
      ApiConstants.customerListEndpoint,
      queryParameters: queryParams,
    );

    if (response is Map<String, dynamic>) {
      final customerListRaw = response['CustomerList'];
      if (customerListRaw is List) {
        final customers = customerListRaw
            .map((item) => CustomerModel.fromJson(item as Map<String, dynamic>))
            .toList();

        return CustomerPaginationResult(
          customers: customers,
          hasMore: customers.length >= pageSize,
        );
      }
    }

    return CustomerPaginationResult(customers: [], hasMore: false);
  }
}
