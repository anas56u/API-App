import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<dynamic>> getProducts();
}