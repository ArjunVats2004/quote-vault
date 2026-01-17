import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'domain/services/notification_service.dart';
import 'domain/services/supabase_service.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/quotes/home_screen.dart';
import 'data/auth_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsModel extends ChangeNotifier {
  String theme = 'system';
  String accent = 'blue';
  double fontScale = 1.0;
  void update({String? theme, String? accent, double? fontScale}) {
    if (theme != null) this.theme = theme;
    if (accent != null) this.accent = accent;
    if (fontScale != null) this.fontScale = fontScale;
    notifyListeners();
  }
  Color get accentColor {
    switch (accent) {
      case 'green':
        return Colors.green;
        case 'red':
          return Colors.red;
          default:
            return Colors.blue;
    }
  }
  ThemeMode get themeMode {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
          default:
            return ThemeMode.system;
    }
  }
}

GoRouter createRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
    ],
  );
}

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  if (status.isGranted) {
    debugPrint("✅ Notification permission granted");
  } else {
    debugPrint("❌ Notification permission denied");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Supabase.initialize(
    url: 'https://tctmpxtakgvwyuzrvgkv.supabase.co',
    anonKey: 'sb_publishable_05RfOS2N0vgbGgqrjnR8rQ_PNQZz22d',
  );
  final token = await AuthStorage.getToken();
  final initialRoute = token != null ? '/home' : '/login';
  final notificationService = NotificationService();
  await notificationService.init();
  await requestNotificationPermission();
  final supabaseService = SupabaseServices();
  final quote = await supabaseService.fetchRandomQuote();
  await notificationService.showInstantNotification(quote);
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return MaterialApp.router(
      routerConfig: createRouter(initialRoute),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:
            settings.theme == 'dark'
                ? Brightness.dark
                : settings.theme == 'light'
                ? Brightness.light
                : Brightness.light,
        primaryColor: const Color(0xFF0D1B2A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1B2A),
          brightness:
              settings.theme == 'dark' ? Brightness.dark : Brightness.light,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: settings.fontScale,
          bodyColor: const Color(0xFF0D1B2A),
          displayColor: const Color(0xFF0D1B2A),
        ),
      ),
    );
  }
}
