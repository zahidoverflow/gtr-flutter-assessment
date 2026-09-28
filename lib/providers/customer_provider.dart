import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

enum CustomerState { initial, loading, loaded, error }

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository _customerRepository;

  CustomerState _state = CustomerState.initial;
  List<CustomerModel> _customers = [];
  String? _errorMessage;

  int _currentPage = 1;
  final int _pageSize = 20;
  String _sortBy = 'Balance';
  String _searchQuery = '';
  bool _hasMore = true;
  bool _isLoadingMore = false;

  CustomerProvider(this._customerRepository);

  CustomerState get state => _state;
  List<CustomerModel> get customers => _customers;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == CustomerState.loading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String get sortBy => _sortBy;
  String get searchQuery => _searchQuery;
  int get totalLoaded => _customers.length;

  // Initial fetch or full refresh
  Future<void> fetchCustomers({bool isRefresh = false}) async {
    if (!isRefresh) {
      _state = CustomerState.loading;
      _errorMessage = null;
      notifyListeners();
    }

    _currentPage = 1;
    _hasMore = true;

    try {
      final result = await _customerRepository.getCustomers(
        pageNo: _currentPage,
        pageSize: _pageSize,
        sortBy: _sortBy,
        searchQuery: _searchQuery,
      );

      _customers = result.customers;
      _hasMore = result.hasMore;
      _state = CustomerState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = CustomerState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Load next page
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _state == CustomerState.loading) return;

    _isLoadingMore = true;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final result = await _customerRepository.getCustomers(
        pageNo: nextPage,
        pageSize: _pageSize,
        sortBy: _sortBy,
        searchQuery: _searchQuery,
      );

      if (result.customers.isNotEmpty) {
        _customers.addAll(result.customers);
        _currentPage = nextPage;
      }
      _hasMore = result.hasMore;
    } catch (e) {
      // Keep existing customers, but record error message
      _errorMessage = 'Failed to load more customers: ${e.toString()}';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Search filter
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    fetchCustomers();
  }

  // Change sorting
  void setSortBy(String newSort) {
    if (_sortBy == newSort) return;
    _sortBy = newSort;
    fetchCustomers();
  }

  void clearSearch() {
    _searchQuery = '';
    fetchCustomers();
  }
}
