import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/customer_provider.dart';
import '../auth/login_screen.dart';
import '../common/error_view.dart';
import '../common/loading_view.dart';
import 'widgets/customer_card.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().fetchCustomers();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 250) {
      context.read<CustomerProvider>().loadMore();
    }
  }

  void _showSortBottomSheet() {
    final customerProvider = context.read<CustomerProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'Sort Customers By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildSortOption(
                title: 'Outstanding Balance (Default)',
                value: 'Balance',
                currentValue: customerProvider.sortBy,
              ),
              _buildSortOption(
                title: 'Customer Name',
                value: 'Name',
                currentValue: customerProvider.sortBy,
              ),
              _buildSortOption(
                title: 'Customer ID',
                value: 'Id',
                currentValue: customerProvider.sortBy,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption({
    required String title,
    required String value,
    required String currentValue,
  }) {
    final isSelected = value == currentValue;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        context.read<CustomerProvider>().setSortBy(value);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<CustomerProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleSpacing: 16,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.border, height: 1),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search by customer name...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
                ),
                style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                onSubmitted: (val) => customerProvider.setSearchQuery(val),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (authProvider.currentUser?.companyName.isNotEmpty == true)
                    Text(
                      authProvider.currentUser!.companyName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  customerProvider.clearSearch();
                  _isSearching = false;
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort Options',
            onPressed: _showSortBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (customerProvider.isLoading) {
            return const LoadingView();
          }

          if (customerProvider.state == CustomerState.error && customerProvider.customers.isEmpty) {
            return ErrorView(
              message: customerProvider.errorMessage ?? 'Failed to load customers',
              onRetry: () => customerProvider.fetchCustomers(),
            );
          }

          if (customerProvider.customers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search_rounded, size: 64, color: AppColors.textMuted.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'No customers found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try changing your search query or sorting options.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      customerProvider.clearSearch();
                      setState(() => _isSearching = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reset Search'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => customerProvider.fetchCustomers(isRefresh: true),
            color: AppColors.primary,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 24),
              itemCount: customerProvider.customers.length + (customerProvider.hasMore ? 1 : 0),
              itemBuilder: (ctx, index) {
                if (index < customerProvider.customers.length) {
                  return CustomerCard(customer: customerProvider.customers[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
