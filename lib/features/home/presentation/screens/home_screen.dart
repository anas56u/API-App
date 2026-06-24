import 'package:api_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:api_app/features/auth/presentation/screens/settings_screen.dart';
import 'package:api_app/features/products/presentation/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المستخدم لعرض ترحيب شخصي
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50], // لون خلفية هادئ وعصري
      appBar: AppBar(
        backgroundColor: Colors.transparent, // شفافية للشريط العلوي لدمجه مع الخلفية
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مرحباً، ${user?.firstName ?? 'بك'}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'ماذا تريد أن تفعل اليوم؟',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          // أيقونة الإعدادات العصرية
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.blue),
                onPressed: () {
                  // الانتقال إلى شاشة الإعدادات
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // بناء بطاقة تفاعلية عصرية للانتقال لصفحة المنتجات
            _buildNavigationCard(
              context: context,
              title: 'تصفح المنتجات',
              subtitle: 'اكتشف أحدث العناصر المضافة للنظام',
              icon: Icons.inventory_2_outlined,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء بطاقات التنقل (Best Practice لتقليل تكرار الكود)
  Widget _buildNavigationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // حواف دائرية عصرية
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), // ظل خفيف جداً
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }
}