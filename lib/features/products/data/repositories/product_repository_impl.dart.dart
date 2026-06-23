import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_api_service.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService apiService;

  ProductRepositoryImpl({required this.apiService});

  @override
  Future<List<Product>> getProducts() async {
    return await apiService.getProducts();
  }
}