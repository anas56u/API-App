import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  ProductProvider(this.getProductsUseCase);

  // حالة التحميل
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // حالة الخطأ
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // قائمة المنتجات التي سنجلبها من الـ API
  List<Product> _products = [];
  List<Product> get products => _products;

  // دالة جلب المنتجات
  Future<void> fetchProducts() async {
    // 1. نبدأ التحميل ونمسح أي أخطاء سابقة
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 2. استدعاء الـ UseCase لجلب البيانات
      final productsList = await getProductsUseCase.call();
      
      // 3. حفظ البيانات في المتغير الخاص بنا
      _products = productsList;
      _isLoading = false;
      notifyListeners(); // تنبيه الـ UI ليعرض المنتجات
      
    } catch (e) {
      // 4. في حال حدوث خطأ
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}