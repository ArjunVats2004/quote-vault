import 'package:flutter/material.dart';
import '../../data/auth_storage.dart';
import '../../data/supabase_client.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _signup() async {
    setState(() => loading = true);
    try {
      final res = await SupabaseService.client.auth.signUp(
        email: emailCtrl.text,
        password: passCtrl.text,
      );

      if (res.session != null) {
        // ✅ Save token here
        await AuthStorage.saveToken(res.session!.accessToken);

        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup failed')),
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
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Signup',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1B2A), // dark blue
              Color(0xFF1B263B), // medium blue
              Color(0xFF415A77), // lighter blue
              Color(0xFF778DA9), // soft light blue
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
                mainAxisSize: MainAxisSize.min,
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
                        backgroundColor: primary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: loading ? null : _signup,
                      child:
                          loading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Signup',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
