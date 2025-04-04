import 'package:chateo/firebase_options.dart';
import 'package:chateo/ui/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

final darkNotifier = ValueNotifier<bool>(false);

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: darkNotifier,
        builder: (BuildContext context, bool isDark, Widget? child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
              return MaterialApp(
                theme: ThemeData(
                  primaryColor: Color(0xFF002DE3),
                ),
                darkTheme: ThemeData.dark(),
                themeMode:
                    darkNotifier.value ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: Splashscreen(),
              );
            },
          );
        });
  }
}
