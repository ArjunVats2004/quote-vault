import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/supabase_client.dart';
import '../../data/repositories/settings_repository.dart';
import '../../domain/models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl = TextEditingController();
  String? avatarUrl;
  String theme = 'system';
  String accent = 'blue';
  double fontScale = 1.0;
  String notificationTime = '08:00';
  bool loading = true;

  Future<void> _loadProfile() async {
    final uid = SupabaseService.client.auth.currentUser?.id;
    if (uid == null) return;
    final res = await SupabaseService.client
        .from('user_profiles')
        .select('*')
        .eq('user_id', uid)
        .maybeSingle();

    if (res != null) {
      final profile = UserProfile.fromJson(res);
      nameCtrl.text = profile.name ?? '';
      avatarUrl = profile.avatarUrl;
      theme = profile.theme ?? 'system';
      accent = profile.accent ?? 'blue';
      fontScale = profile.fontScale ?? 1.0;
      notificationTime = profile.notificationTime ?? '08:00';
    }
    setState(() => loading = false);
  }

  Future<void> _saveProfile() async {
    final uid = SupabaseService.client.auth.currentUser?.id;
    if (uid == null) return;
    try {
      await SupabaseService.client.from('user_profiles').upsert({
        'user_id': uid,
        'name': nameCtrl.text,
        'avatar_url': avatarUrl,
        'theme': theme,
        'accent': accent,
        'font_scale': fontScale,
        'notification_time': notificationTime,
      });
      await SettingsRepository().saveLocal(
        theme: theme,
        accent: accent,
        fontScale: fontScale,
        notificationTime: notificationTime,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final uid = SupabaseService.client.auth.currentUser?.id;
      final path = 'avatars/$uid.png';
      await SupabaseService.client.storage.from('avatars').upload(path, file.readAsBytes().asStream() as File);
      final publicUrl = SupabaseService.client.storage.from('avatars').getPublicUrl(path);
      setState(() => avatarUrl = publicUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null ? const Icon(Icons.person, size: 40) : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: theme,
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System')),
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (v) => setState(() => theme = v!),
            ),
            DropdownButton<String>(
              value: accent,
              items: const [
                DropdownMenuItem(value: 'blue', child: Text('Blue')),
                DropdownMenuItem(value: 'green', child: Text('Green')),
                DropdownMenuItem(value: 'red', child: Text('Red')),
              ],
              onChanged: (v) => setState(() => accent = v!),
            ),
            Slider(
              value: fontScale,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: 'Font scale: $fontScale',
              onChanged: (v) => setState(() => fontScale = v),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
