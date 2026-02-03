import 'package:flutter/material.dart';

class CharacterCreationScreen extends StatelessWidget {
  const CharacterCreationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criação de Personagem')),
      body: const Center(child: Text('Formulário de Altura, Peso e Idade')),
    );
  }
}
