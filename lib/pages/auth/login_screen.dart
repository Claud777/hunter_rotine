import 'package:flutter/material.dart';
import 'package:hunter_rotine/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instanciamos o controller localmente no State
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Prática sênior: Sempre limpar controllers para evitar memory leaks
    _emailController.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título com pegada RPG
              Text(
                'HUNTER ROTINE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inicie sua jornada épica.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail do Hunter',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Insira um e-mail válido para a associação.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // O ListenableBuilder reconstrói apenas o botão baseado no estado do controller
              ListenableBuilder(
                listenable: _authController,
                builder: (context, _) {
                  return ElevatedButton(
                    onPressed: _authController.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _authController.sendMagicLink(
                                _emailController.text.trim(),
                                context,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _authController.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('ENVIAR MAGIC LINK'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
