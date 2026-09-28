import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/network/api_client.dart';
import 'core/services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/customer_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/customer_repository.dart';
import 'views/auth/login_screen.dart';
import 'views/customer/customer_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = await StorageService.init();

  // Initialize network & repositories
  final apiClient = ApiClient(storageService);
  final authRepository = AuthRepository(apiClient, storageService);
  final customerRepository = CustomerRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider<CustomerProvider>(
          create: (_) => CustomerProvider(customerRepository),
        ),
      ],
      child: const GtrCustomerApp(),
    ),
  );
}

class GtrCustomerApp extends StatelessWidget {
  const GtrCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GTR Customer Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        fontFamily: 'Roboto',
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            return const CustomerListScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
