import 'package:api_app/features/auth/data/datasources/auth_api_service.dart';
import 'package:api_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:api_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:api_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:api_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(apiService: authApiService);
  final loginUseCase = LoginUsecase(repository: authRepository);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(loginUsecase: loginUseCase)),
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
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), 
    );
  }
}
