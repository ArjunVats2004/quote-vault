import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/settings_repository.dart';
import '../../main.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String theme = 'system';
  String accent = 'blue';
  double fontScale = 1.0;
  String notificationTime = '08:00';

  Future<void> _save() async {
    await SettingsRepository().saveLocal(
      theme: theme,
      accent: accent,
      fontScale: fontScale,
      notificationTime: notificationTime,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }


  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed out successfully')),
        );
        context.go('/login'); // 👈 cleaner navigation with GoRouter
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Theme',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: theme,
                  dropdownColor: primary,
                  items: const [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(
                        'System',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        'Light',
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        'Dark',
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => theme = v!),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Accent Color',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: accent,
                  dropdownColor: primary,
                  items: const [
                    DropdownMenuItem(
                      value: 'blue',
                      child: Text(
                        'Blue',
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'green',
                      child: Text(
                        'Green',
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'red',
                      child: Text(
                        'Red',
                        style: TextStyle(color: Colors.orange, fontSize: 20),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => accent = v!),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Font Scale',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: fontScale,
                  min: 0.8,
                  max: 1.5,
                  divisions: 7,
                  label: fontScale.toStringAsFixed(2),
                  activeColor: Colors.orange,
                  onChanged: (v) => setState(() => fontScale = v),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Provider.of<SettingsModel>(
                      context,
                      listen: false,
                    ).update(theme: theme, accent: accent, fontScale: fontScale);
                    _save();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _signOut,
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
