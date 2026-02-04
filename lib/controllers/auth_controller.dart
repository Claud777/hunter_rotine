import 'package:flutter/material.dart';
import 'package:hunter_rotine/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Dispara o Magic Link e gerencia o estado da UI
  Future<void> sendMagicLink(String email, BuildContext context) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.signInWithMagicLink(email);

      // Verificação rigorosa após chamada assíncrona
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Verifique seu e-mail para acessar o portal do Hunter!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _errorMessage = e.toString();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notifica a UI para mostrar/esconder o loading
  }
}
