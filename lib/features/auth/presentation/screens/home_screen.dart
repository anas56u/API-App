import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// أفضل ممارسة: جعلنا الشاشة StatelessWidget لأنها لا تحتوي على حالة داخلية (State)
// بل تعتمد كلياً على البيانات القادمة من الـ Provider
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // نقرأ بيانات الـ AuthProvider للوصول للمستخدم الحالي
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        actions: [
          // زر تسجيل الخروج (أفضل ممارسة لإعطاء تجربة مستخدم كاملة)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // هنا يمكنك إغلاق الشاشة والعودة للـ Login
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('لا توجد بيانات مستخدم متوفرة'))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.person, size: 40),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // 1. عرض الـ ID
                        _buildUserDetail('الرقم المعرف (ID):', '${user.id}'),
                        const Divider(),

                        // 2. عرض الاسم الكامل (الاسم الأول + الأخير)
                        _buildUserDetail('الاسم:', '${user.firstName} ${user.lastName}'),
                        const Divider(),

                        // 3. عرض اسم المستخدم (Username)
                        _buildUserDetail('اسم المستخدم:', user.username),
                        const Divider(),

                        // 4. عرض البريد الإلكتروني (Email)
                        _buildUserDetail('البريد الإلكتروني:', user.email),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // دالة مساعدة (Helper Method) لمنع تكرار كود التصميم (Best Practice - DRY)
  Widget _buildUserDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
        ],
      ),
    );
  }
}