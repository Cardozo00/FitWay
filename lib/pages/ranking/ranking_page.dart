import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/usuario/usuario.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final User user;
  const RankingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Ranking'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('usuarios')
              .orderBy('totalPontos', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var e = snapshot.data!.docs[index];
                      var usuarioModal = UsuarioModel.fromJson(
                          e.data() as Map<String, dynamic>);
                      bool isCurrentUser =
                          usuarioModal.name == user.displayName;

                      // Define a cor e o estilo para os três primeiros
                      Color circleColor;
                      if (index == 0) {
                        circleColor = Colors.amber; // Dourado
                      } else if (index == 1) {
                        circleColor = Colors.grey; // Prata
                      } else if (index == 2) {
                        circleColor = Colors.brown; // Bronze
                      } else {
                        circleColor = Colors.transparent; // Sem círculo
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Ícone com círculo para os 3 primeiros
                                      if (index < 3)
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: circleColor,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      else
                                        // Apenas o número para os outros
                                        Text('${index + 1}.',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isCurrentUser
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            )),
                                      const SizedBox(width: 10),
                                      // Nome do usuário
                                      Text(
                                        usuarioModal.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isCurrentUser
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    usuarioModal.totalPontos.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isCurrentUser
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
