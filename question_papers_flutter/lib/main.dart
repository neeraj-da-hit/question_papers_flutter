import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/bottom_navbar.dart';
import 'package:question_papers_flutter/core/init_dependencies.dart';
import 'package:question_papers_flutter/helpers/navigation_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      /// ✅ attach your global navigation key here
      navigatorKey: navigatorKey,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BottomNavBar(),
    );
  }
}
