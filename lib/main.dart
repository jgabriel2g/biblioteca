import 'package:biblioteca_cuc/pages/home_page.dart';
import 'package:biblioteca_cuc/pages/login_page.dart';
import 'package:biblioteca_cuc/pages/register_page.dart';
import 'package:biblioteca_cuc/pages/user_loan_page.dart';
import 'package:biblioteca_cuc/pages/user_page.dart';
import 'package:biblioteca_cuc/pages/book_page.dart';
import 'package:biblioteca_cuc/provider/login_provider.dart';
import 'package:biblioteca_cuc/provider/register_provider.dart';
import 'package:biblioteca_cuc/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => LoginProvider()),
        ChangeNotifierProvider(lazy: false, create: (_) => RegisterProvider())
      ],
      child: MaterialApp(
        initialRoute: Routes.login,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.login:
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case Routes.register:
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case Routes.home:
              final user = settings.arguments as User;
              return MaterialPageRoute(
                builder: (_) => HomePage(userData: user),
              );
            case Routes.user:
              final id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => UserPage(id: id),
              );
            case Routes.userLoan:
              final id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => UserLoanPage(id: id),
              );
            case Routes.book:
              final id = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => BookPage(id: id),
              );
            default:
              return MaterialPageRoute(builder: (_) => const LoginPage());
          }
        },
      ),
    );
  }
}
