import 'package:e_commerce/common/no_internet_connection/no_internet_connection_screen.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/forget_password_provider.dart';
import 'package:e_commerce/providers/authentication/login_provider.dart';
import 'package:e_commerce/providers/authentication/registration_provider.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/profile_updation/profile_updation_provider.dart';
import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/authentication/splash_screen/splash_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //bool connected = await InternetConnection().hasInternetAccess;
  // if (connected) {
  runApp(const MyApp());
  // } else {
  //runApp(const NoConnectionScreen());
  //}
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileUpdationProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
