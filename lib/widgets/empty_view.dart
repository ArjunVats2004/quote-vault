import 'package:flutter/material.dart';
import '../app_router.dart';
import '../data/supabase_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const QuoteVaultApp());
}

class QuoteVaultApp extends StatelessWidget {
  const QuoteVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QuoteVault',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: appRouter,
    );
  }
}
