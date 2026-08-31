import 'package:shared_preferences/shared_preferences.dart';

/// قراءة بيانات الجلسة المحفوظة بعد الـ login.
/// الـ LoginRepo هو اللي بيحفظ المفاتيح دي.
class SessionManager {
  const SessionManager._();

  static const String roleKey = 'roleName';
  static const String tokenKey = 'token';

  /// الرول المطلوبة لفتح لوحة الإكسيل.
  static const String superAdminRole = 'superadmin';

  static Future<String> roleName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleKey) ?? '';
  }

  /// بنشيل المسافات ونوحّد حالة الحروف لأن السيرفر ممكن يرجّع
  /// "SuperAdmin" أو "Super Admin" أو "superadmin".
  static String normalizeRole(String role) =>
      role.replaceAll(' ', '').replaceAll('_', '').toLowerCase();

  /// ملاحظة: الجلسات القديمة اللي عملت login قبل إضافة حفظ الرول
  /// مش هيكون عندها المفتاح ده، فبترجع false لحد ما المستخدم
  /// يعمل login تاني. التوكن نفسه مفيهوش claim للرول.
  static Future<bool> isSuperAdmin() async {
    final role = await roleName();
    return normalizeRole(role) == superAdminRole;
  }
}
