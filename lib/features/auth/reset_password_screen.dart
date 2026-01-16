import 'package:flutter/material.dart';
import '../../data/supabase_client.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> _reset() async {
    setState(() => loading = true);
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(emailCtrl.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _reset,
              child: loading ? const CircularProgressIndicator() : const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
