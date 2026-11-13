import 'package:finnot/users_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const FinnotApp());
}

class FinnotApp extends StatelessWidget {
  const FinnotApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF241C16);
    const paper = Color(0xFFF4EFE4);

    return MaterialApp(
      title: 'Finnot',
      theme: ThemeData(
        fontFamily: 'CourierPrime',
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: paper,
          foregroundColor: ink,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'CourierPrime',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: ink,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'CourierPrime',
            fontSize: 16,
            height: 1.4,
            color: ink,
          ),
          titleLarge: TextStyle(
            fontFamily: 'CourierPrime',
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: ink,
          ),
        ),
      ),
      home: const UsersPage(),
    );
  }
}
