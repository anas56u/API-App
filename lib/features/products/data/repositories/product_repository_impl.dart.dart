
import 'package:api_app/features/products/data/datasources/product_api_service.dart';
import 'package:api_app/features/products/domain/entities/product.dart';
import 'package:api_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<List<Product>> getProducts() async {
    return await apiService.getProducts();
  }
}