import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoricoPage extends StatelessWidget {
  final User user;
  const HistoricoPage({super.key, required this.user});

  // Função para formatar a data de forma abreviada
  String formatarData(DateTime data) {
    return DateFormat('d MMM yyyy').format(data); // Exemplo: 24 Nov 2024
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Missões"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('historico_missoes')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var missoes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: missoes.length,
            itemBuilder: (context, index) {
              var missao = missoes[index].data() as Map<String, dynamic>;
              var dataConcluida = missao['data'].toDate() as DateTime;

              // Formatar a data
              String dataFormatada = formatarData(dataConcluida);

              return ListTile(
                title: Text(missao['nome']),
                subtitle: Text('Concluída em: $dataFormatada'),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
