import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Ajuste os nomes abaixo conforme o nome real do seu projeto no pubspec.yaml
import 'package:hunter_rotine/pages/auth/login_screen.dart';
import 'package:hunter_rotine/pages/character/character_creation_screen.dart';
import 'package:hunter_rotine/pages/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xihcwlcsmkgeelokbcwf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpaGN3bGNzbWtnZWVsb2tiY3dmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4NzM0OTksImV4cCI6MjA4MDQ0OTQ5OX0.Qgq7PJtDvKdL-Ke1tZUo-S7MUnncDFAB1IHxTbVsQfU',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const HunterRotine());
}

class HunterRotine extends StatelessWidget {
  const HunterRotine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunter Rotine',
      theme: ThemeData.dark(), // Estilo RPG
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if (session == null) {
          return const LoginScreen(); // Onde pediremos o e-mail
        }

        // Se houver sessão, verificamos se o personagem já foi "criado"
        return FutureBuilder<PostgrestMap?>(
          future: _getUserProfile(session.user.id),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final data = profileSnapshot.data;
            // Lógica: Se o nome for o padrão do Trigger ou atributos zerados
            if (data == null || data['name'] == 'User') {
              return const CharacterCreationScreen();
            }

            return const DashboardScreen();
          },
        );
      },
    );
  }

  Future<PostgrestMap?> _getUserProfile(String userId) async {
    return await Supabase.instance.client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }
}
