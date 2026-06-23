import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product; // نستقبل المنتج من الشاشة السابقة

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. عرض الصورة الأساسية (Thumbnail)
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(product.thumbnail, fit: BoxFit.contain),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. العنوان والسعر والتقييم
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${product.rating} ', style: const TextStyle(fontSize: 16)),
                      Text('(${product.category})', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // 3. الوصف
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),

                  // 4. المراجعات (Reviews)
                  const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  
                  // إذا لم يكن هناك تقييمات
                  if (product.reviews.isEmpty)
                    const Text('No reviews yet.'),
                  
                  // عرض التقييمات باستخدام ListView مدمج
                  ...product.reviews.map((review) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        child: Text(review.reviewerName[0]), // أول حرف من اسم المُقيّم
                      ),
                      title: Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(review.comment),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${review.rating}'),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}