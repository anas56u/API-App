import 'package:api_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:api_app/features/cart/presentation/screnns/cart_screen.dart';
import 'package:api_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Best Practice: استدعاء الـ API مرة واحدة فقط عند فتح الشاشة
    // نستخدم addPostFrameCallback لضمان استدعاء الـ Provider بعد بناء الشاشة الأولي
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Products', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // إضافة أيقونة السلة مع عداد (Badge)
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Badge(
                // نعرض العداد فقط إذا كان هناك منتجات في السلة
                isLabelVisible: cartProvider.itemCount > 0,
                label: Text(cartProvider.itemCount.toString()),
                offset: const Offset(-5, 5),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                  onPressed: () {
                    // الانتقال لشاشة السلة
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      
      body: _buildBody(productProvider),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => provider.fetchProducts(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (provider.products.isEmpty) {
      return const Center(child: Text('لا توجد منتجات.'));
    }

    // هنا نقوم بدمج قسم التصنيفات (Categories) وقسم المنتجات في عمود واحد
    return Column(
      children: [
        // 1. شريط التصنيفات (Categories Bar)
        _buildCategoriesBar(provider),

        // 2. شبكة المنتجات (Products Grid)
        // نستخدم Expanded لكي تأخذ الشبكة المساحة المتبقية من الشاشة
        Expanded(
          // لاحظ أننا نستخدم provider.filteredProducts هنا وليس provider.products
          child: provider.filteredProducts.isEmpty
              ? const Center(child: Text('لا توجد منتجات في هذا التصنيف.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = provider.filteredProducts[index];
                    return _buildProductCard(context, product);
                  },
                ),
        ),
      ],
    );
  }

  // دالة مساعدة لبناء شريط التصنيفات (لفصل الكود وجعله Clean)
  Widget _buildCategoriesBar(ProductProvider provider) {
    return SizedBox(
      height: 60, // ارتفاع ثابت لشريط التصنيفات
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // تمرير أفقي
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final isSelected = category == provider.selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0), // مسافة بين الأزرار
            child: ChoiceChip(
              checkmarkColor: Colors.white,
              label: Text(
                // يمكنك استخدام دالة هنا لترجمة الكلمات الإنجليزية للعربية إن أردت
                category.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.blue.shade700, // لون الزر المختار
              backgroundColor: Colors.white, // لون الزر غير المختار
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // حواف دائرية عصرية
              ),
              onSelected: (bool selected) {
                // عند الضغط على التصنيف، نرسل الأمر للـ Provider
                if (selected) {
                  provider.changeCategory(category);
                }
              },
            ),
          );
        },
      ),
    );
  }

  // دالة مساعدة لبناء كارت المنتج (أخذنا الكود القديم الخاص بك ووضعناه هنا لنظافة الكود)
  Widget _buildProductCard(BuildContext context, dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                product.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),InkWell(
                        onTap: () {
                          // استدعاء دالة الإضافة (نستخدم read لأننا نرسل حدثاً فقط)
                          context.read<CartProvider>().addItem(
                                product.id,
                                product.title,
                                product.price.toDouble(), // تحويل للسعر العشري
                                product.thumbnail,
                              );
                              
                          // إظهار رسالة تأكيد لطيفة للمستخدم
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت الإضافة إلى السلة!'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating, // شكل عصري عائم
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.add_shopping_cart, size: 20, color: Colors.blue.shade700),
                        ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
