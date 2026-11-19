import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'routes/app_pages.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App Teknologi Indonesia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      scrollBehavior: const AppScrollBehavior(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...super.dragDevices,
        PointerDeviceKind.mouse,
      };
}
