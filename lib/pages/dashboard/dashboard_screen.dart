import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hunter Rotine - Dashboard')),
      body: const Center(
        child: Text('Bem-vindo, Hunter! Suas missões aguardam.'),
      ),
    );
  }
}
