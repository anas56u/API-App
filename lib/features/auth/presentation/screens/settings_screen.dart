import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/auth/presentation/screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // حالات محلية للتحكم في مفاتيح التشغيل/الإيقاف داخل الشاشة
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    // الاستماع لبيانات المستخدم من الـ AuthProvider
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100], // خلفية رمادية فاتحة لإبراز البطاقات البيضاء
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: user == null
          ? const Center(child: Text('No user data available'))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              children: [
                // --- PROFILE HEADER SECTION ---
                Center(
                  child: Column(
                    children: [
                      // صورة رمزية للمستخدم تعتمد على الحرف الأول من اسمه واسم عائلته
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${user.firstName[0]}${user.lastName[0]}'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // عرض الاسم الكامل للمستخدم
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // عرض البريد الإلكتروني
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // عرض معرف الـ ID بشكل شارة (Badge/Chip) أنيقة
                      Chip(
                        label: Text('User ID: ${user.id}'),
                        backgroundColor: Colors.blue.shade50,
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: Colors.blue.shade700, 
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // --- SECTION 1: ACCOUNT DETAILS ---
                _buildSectionTitle('Account Details'),
                _buildSettingsGroup([
                  _buildListTile(
                    icon: Icons.person_outline,
                    title: 'Username',
                    trailingText: user.username,
                  ),
                  _buildListTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      // منطق تغيير كلمة المرور مستقبلاً
                    },
                  ),
                ]),
                const SizedBox(height: 20),

                // --- SECTION 2: PREFERENCES ---
                _buildSectionTitle('Preferences'),
                _buildSettingsGroup([
                  _buildSwitchListTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    value: _isDarkMode,
                    onChanged: (val) {
                      setState(() {
                        _isDarkMode = val;
                      });
                    },
                  ),
                  _buildSwitchListTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Push Notifications',
                    value: _isNotificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        _isNotificationsEnabled = val;
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 20),

                // --- SECTION 3: APP INFO & SUPPORT ---
                _buildSectionTitle('Support'),
                _buildSettingsGroup([
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: 'Help & Feedback',
                    onTap: () {},
                  ),
                  _buildListTile(
                    icon: Icons.info_outline,
                    title: 'About Application',
                    trailingText: 'v1.0.0',
                  ),
                ]),
                const SizedBox(height: 24),

                // --- LOGOUT BUTTON ---
                Card(
                  elevation: 0,
                  color: Colors.red.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () {
                      // العودة لصفحة تسجيل الدخول وتدمير شاشة الإعدادات من الذاكرة
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout Account',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // دالة مساعدة لبناء عنوان القسم (تُكتب بالحروف الكبيرة لمظهر احترافي)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // تجميع عناصر الإعدادات داخل بطاقة بيضاء موحدة بحواف دائرية (Best Practice لتنظيم الـ UI)
  Widget _buildSettingsGroup(List<Widget> tiles) {
    return Card(
      elevation: 0, // إلغاء الظل الثقيل واستبداله بنظافة حواف البطاقة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // يضمن عدم خروج الـ Tiles عن حواف الـ Card الدائرية
      child: Column(
        children: tiles,
      ),
    );
  }

  // بناء عنصر قائمة عادي (ListTile)
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87),
      ),
      trailing: trailingText != null
          ? Text(
              trailingText,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            )
          : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  // بناء عنصر قائمة يحتوي على مفتاح تشغيل/إيقاف (SwitchListTile)
  Widget _buildSwitchListTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.blue.shade700),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black87),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue.shade700,
    );
  }
}