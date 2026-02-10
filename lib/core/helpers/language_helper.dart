import 'package:task_dashboard/core/helpers/constance.dart';
import 'package:task_dashboard/core/helpers/shared_pref.dart';

class LanguageHelper {
  /// Get current language from SharedPreferences
  /// Returns 'ar' as default if not found
  static Future<String> getLanguage() async {
    final language = await SharedPrefHelper.getString(SharedPrefKeys.language);
    return language.isNotEmpty ? language : 'ar';
  }
}
