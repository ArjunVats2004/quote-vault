import 'package:flutter/material.dart';
import '../../data/auth_storage.dart';
import '../../data/supabase_client.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      final res = await SupabaseService.client.auth.signInWithPassword(
        email: emailCtrl.text,
        password: passCtrl.text,
      );

      if (res.session != null) {
        // ✅ Save token here
        await AuthStorage.saveToken(res.session!.accessToken);

        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
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
    final primary = Theme.of(context).primaryColor; // 👈 use your theme color

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w300)),
        backgroundColor: primary,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A),
              Color(0xFF1B263B),
              Color(0xFF415A77),
              Color(0xFF778DA9),
            ],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 👈 keeps it centered
                children: [
                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary.withOpacity(
                          0.8,
                        ), // 👈 light blue
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : _login,
                      child:
                          loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w300),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/signup'),
                    child: const Text('Create account',style: TextStyle(fontWeight: FontWeight.w300,color: Color(0xFF0D1B2A),fontSize: 20),),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextButton(
                    onPressed: () => context.go('/reset-password'),
                    child: const Text('Forgot Password?'),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
