import 'package:api_app/features/auth/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // للتحكم في النصوص المدخلة
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Best Practice: دائماً قم بإغلاق الـ Controllers عند تدمير الشاشة لتجنب تسريب الذاكرة (Memory Leaks)
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام context.watch لقراءة حالة الـ Provider وجعل الشاشة تتحدث عند أي تغيير
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // حقل اسم المستخدم
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'اسم المستخدم (Username)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // حقل كلمة المرور
            TextField(
              controller: _passwordController,
              obscureText: true, // لإخفاء كلمة المرور
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // عرض رسالة خطأ إن وجدت
            if (authProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  authProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            // زر تسجيل الدخول أو دائرة التحميل
            SizedBox(
              width: double.infinity,
              height: 50,
              child: authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        // جلب البيانات من الـ Controllers
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();

                        if (username.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('الرجاء إدخال جميع البيانات')),
                          );
                          return;
                        }

                        // استدعاء دالة الـ Provider المخفية باستخدام context.read (لأننا لا نريد إعادة رسم الشاشة هنا، فقط إرسال أمر)
                        final success = await context.read<AuthProvider>().login(username, password);

                        if (success) {
                          // إذا نجح تسجيل الدخول، يمكننا طباعة رسالة أو الانتقال للصفحة الرئيسية لاحقاً
                           ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
                          );
                          Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const SettingsScreen()),
  );
                        }
                      },
                      child: const Text('دخول', style: TextStyle(fontSize: 18)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}