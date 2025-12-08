import 'package:flutter/material.dart';
import 'home_admin_page.dart';
import 'home_user_page.dart';

class LoginPage extends StatefulWidget {
  final Function(String role) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void _login() {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email == 'admin@gmail.com' && senha == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeAdminPage()),
      );
    } else if (email == 'user@gmail.com' && senha == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeUserPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciais inválidas!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/Logo.png',
                width: 200, // aumenta o tamanho horizontal
                height: 200, // aumenta o tamanho vertical
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
