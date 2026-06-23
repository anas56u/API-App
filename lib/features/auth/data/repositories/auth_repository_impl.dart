import 'package:api_app/features/auth/data/datasources/auth_api_service.dart';
import 'package:api_app/features/auth/domain/entities/user.dart';
import 'package:api_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthApiService apiService;

  AuthRepositoryImpl({required this.apiService});

  @override
 Future <User> login ( String username ,String password ) async {

  return await apiService.login(
      username: username, 
      password: password,
    );

 }
}