import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_dashboard/core/routing/app_router.dart';
import 'package:task_dashboard/core/theming/app_theme.dart';
import 'package:task_dashboard/core/di/dependency_injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    // On web: ensure Firebase JS SDK is loaded in web/index.html
    // and that your domain is in Firebase Console > Auth > Authorized domains
    debugPrint('Firebase init error: $e');
    debugPrint('Stack: $st');
    rethrow;
  }

  await setupDependencyInjection();

  runApp(const InventraApp());
}

class InventraApp extends StatelessWidget {
  const InventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024), // Desktop design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Inventra Dashboard',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
