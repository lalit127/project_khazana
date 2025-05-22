import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical_khazana/common/status_bar_color_controller.dart';
import 'package:practical_khazana/common/common_import.dart';
import 'package:practical_khazana/config/theme/theme.dart';
import 'package:practical_khazana/routes/app_pages.dart';
import 'package:sizer/sizer.dart' as sizer;
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://opzthdacuiharuconvrm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wenRoZGFjdWloYXJ1Y29udnJtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3MTQ3ODMsImV4cCI6MjA2MzI5MDc4M30.uuNuwI-cUo71-1tq32OmXuhHj6Q42yihyIDWzjfizLQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Get.put(StatusBarColorController());
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (
        BuildContext context,
        Orientation orientation,
        sizer.ScreenType deviceType,
      ) {
        StatusBarColorController statusBarColorController = Get.put(
          StatusBarColorController(),
        );
        ThemeMode themeMode = statusBarColorController.themeMode;
        return MaterialApp(
          theme: AppThemes.lightTheme,
          debugShowCheckedModeBanner: false,
          home: GetMaterialApp(
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.lightTheme,
            themeMode: themeMode,
            title: 'Practical',
            // localizationsDelegates: const [
            //   AppLocalizations.delegate,
            // ],
            locale: const Locale('en'),
            supportedLocales: const [Locale('en', ''), Locale('ko', '')],
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
