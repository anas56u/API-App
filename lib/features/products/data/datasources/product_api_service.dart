import 'dart:convert';
import 'package:api_app/features/products/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductApiService {
  final String productsUrl = 'https://dummyjson.com/products';

  Future<List<ProductModel>> getProducts() async {
    try {
      final url = Uri.parse(productsUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        final List<dynamic> productsJsonList = responseData['products'];
        
        return productsJsonList.map((json) => ProductModel.fromJson(json)).toList();
        
      } else {
        throw Exception("فشل جلب المنتجات. كود الخطأ: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء الاتصال: $e");
    }
  }
}