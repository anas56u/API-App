import 'package:api_app/features/auth/data/datasources/auth_api_service.dart';
import 'package:api_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:api_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:api_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:api_app/features/auth/presentation/screens/login_screen.dart';
import 'package:api_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:api_app/features/home/presentation/screens/home_screen.dart';
import 'package:api_app/features/products/data/datasources/product_api_service.dart';
import 'package:api_app/features/products/data/repositories/product_repository_impl.dart.dart';
import 'package:api_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:api_app/features/products/presentation/providers/product_provider.dart';
import 'package:api_app/features/products/presentation/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(apiService: authApiService);
  final loginUseCase = LoginUsecase(repository: authRepository);
  final productApiService = ProductApiService();
  final productRepository = ProductRepositoryImpl(apiService: productApiService);
  final getProductsUseCase = GetProductsUseCase(productRepository);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(loginUsecase: loginUseCase)),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(getProductsUseCase),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Clean Arch App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, 
      ),
      home: const HomeScreen(), 
    );
  }
}
