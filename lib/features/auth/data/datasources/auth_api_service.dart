import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart'; // تأكد من صحة مسارك

class AuthApiService {
  final String loginUrl = 'https://dummyjson.com/auth/login';

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse(loginUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}), 
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserModel.fromjson(responseData); 
      } 
      else {
        throw Exception("فشل تسجيل الدخول: تأكد من البيانات المدخلة");
      }

    } catch (e) {
     
      throw Exception("حدث خطأ في الاتصال بالخادم: $e");
    }
  }
}