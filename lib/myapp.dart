import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/pages/home/formulario_avalicao.dart';
import 'package:fitwayapp/pages/login/login_page.dart';
import 'package:fitwayapp/pages/login/splash_screen.dart';
import 'package:fitwayapp/pages/tela_inical/tela_inical.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RoteadorTela(),
    );
  }
}

class RoteadorTela extends StatefulWidget {
  const RoteadorTela({super.key});

  @override
  State<RoteadorTela> createState() => _RoteadorTelaState();
}

class _RoteadorTelaState extends State<RoteadorTela> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          final User user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('usuarios')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen(
                  logoPath: 'assets/icon/logofit.png',
                );
              }

              if (snapshot.hasData && snapshot.data!.exists) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                final bool formularioPreenchido =
                    data['formularioPreenchido'] ?? false;

                if (formularioPreenchido) {
                  return TelaInical(user: user);
                } else {
                  return FormularioAvalicao(user: user);
                }
              } else {
                return const Center(child: Text('Erro ao carregar dados.'));
              }
            },
          );
        } else {
          return const TelaLogin(user: null);
        }
      },
    );
  }
}
