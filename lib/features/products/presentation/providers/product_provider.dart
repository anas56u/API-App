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

  List<Product> _products = [];
  List<Product> get products => _products;
  String _selectedCategory = 'الكل';
  String get selectedCategory => _selectedCategory;
  List<String> get categories {
    final uniqueCategories = _products.map((p) => p.category).toSet().toList();

    return ['الكل', ...uniqueCategories];
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == 'الكل') {
      return _products; // إذا كان 'الكل'، نعرض القائمة الأصلية كاملة
    }
    // دالة where تقوم بالبحث داخل القائمة وإرجاع المنتجات التي يطابق تصنيفها التصنيف المختار
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  // 4. دالة لتغيير التصنيف المختار عند ضغط المستخدم على زر التصنيف
  void changeCategory(String newCategory) {
    _selectedCategory = newCategory;
    notifyListeners(); // إشعار واجهة المستخدم لإعادة رسم شاشة المنتجات
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 2. استدعاء الـ UseCase لجلب البيانات
      final productsList = await getProductsUseCase.call();

      // 3. حفظ البيانات في المتغير الخاص بنا
      _products = List<Product>.from(productsList);
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
