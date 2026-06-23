import 'package:api_app/features/auth/domain/entities/user.dart';
import 'package:api_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});
  Future<User> call(String username, String password) async {
    return await repository.login(username, password);
  }
  
}