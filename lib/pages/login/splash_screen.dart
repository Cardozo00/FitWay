import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final String logoPath; // Caminho da logo
  const SplashScreen({Key? key, required this.logoPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A6D92),
      body: Center(
        child: Image.asset(
          logoPath,
          width: 150, // Ajuste o tamanho conforme necessário
          height: 150,
        ),
      ),
    );
  }
}
