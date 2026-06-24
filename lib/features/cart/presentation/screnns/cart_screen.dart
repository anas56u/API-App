import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم context.watch لأن الشاشة بأكملها تعتمد على بيانات السلة
    final cartProvider = context.watch<CartProvider>();
    // استخراج قائمة المنتجات من الـ Map
    final cartItems = cartProvider.items.values.toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('سلة المشتريات', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // زر تفريغ السلة
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              onPressed: () {
                cartProvider.clear();
              },
            )
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('السلة فارغة', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child:// في ملف cart_screen.dart

ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: cartItems.length,
  itemBuilder: (context, index) {
    final item = cartItems[index];
    
    // نغلف الكارت بـ Dismissible
    return Dismissible(
      key: ValueKey(item.id), // مفتاح فريد لكل عنصر (ضروري جداً لـ Flutter)
      direction: DismissDirection.startToEnd, // السحب من اليمين لليسار فقط
      background: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        // عند اكتمال السحب، نحذف المنتج بالكامل
        context.read<CartProvider>().removeItem(item.id);
        
        // اختيارياً: إظهار رسالة تراجع (Undo)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم حذف ${item.title}'),
            action: SnackBarAction(
              label: 'تراجع',
              onPressed: () {
                // يمكنك إعادة الإضافة هنا إذا أردت (منطق برمجي إضافي)
              },
            ),
          ),
        );
      },
      child: _buildCartItemCard(context, item, cartProvider),
    );
  },
),
                ),
                // قسم الدفع في الأسفل
                _buildCheckoutSection(context, cartProvider.totalAmount),
              ],
            ),
    );
  }

  // كارت يعرض المنتج داخل السلة بأسلوب نظيف
  Widget _buildCartItemCard(BuildContext context, dynamic item, CartProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.thumbnail,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // تفاصيل المنتج (الاسم والسعر)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price}',
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // أزرار التحكم بالكمية
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                  onPressed: () {
                    provider.removeSingleItem(item.id);
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: Colors.blue.shade700),
                  onPressed: () {
                    provider.addItem(item.id, item.title, item.price, item.thumbnail);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // قسم الإجمالي وزر الدفع في أسفل الشاشة
  Widget _buildCheckoutSection(BuildContext context, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الإجمالي:',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}', // تحديد رقمين بعد الفاصلة
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  // منطق الدفع مستقبلاً
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('قريباً: الانتقال لبوابة الدفع!')),
                  );
                },
                child: const Text(
                  'إتمام الطلب',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}