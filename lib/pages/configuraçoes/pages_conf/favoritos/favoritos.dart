import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatelessWidget {
  final User user;
  const FavoritosPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff0A6D92),
        title: const Text(
          'Missões favoritas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('usuarios')
            .doc(user.uid)
            .collection('favoritos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma missão favorita.'));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ListView(
                children: snapshot.data!.docs.map((doc) {
                  // Extrai os dados da missão
                  final nomeMissao = doc['nome'] ?? 'Missão sem nome';
                  final missaoId = doc.id;

                  // Verifica se o campo 'favorito' existe e atribui um valor padrão se necessário
                  final favorito = (doc.data() != null &&
                          (doc.data() as Map<String, dynamic>)
                              .containsKey('favorito'))
                      ? doc['favorito']
                      : false;

                  return Card(
                    elevation: 8,
                    child: ListTile(
                      title: Text(nomeMissao),
                      trailing: IconButton(
                        icon: Icon(
                          favorito ? Icons.favorite_border : Icons.favorite,
                          color: favorito ? Colors.grey : Colors.red,
                        ),
                        onPressed: () async {
                          final novoFavorito = favorito;

                          // Atualiza o estado no Firebase
                          if (novoFavorito) {
                            await db
                                .collection('usuarios')
                                .doc(user.uid)
                                .collection('favoritos')
                                .doc(missaoId)
                                .set({
                              'id': missaoId,
                              'nome': nomeMissao,
                              'favorito': true,
                              'data': Timestamp.now(),
                            });
                          } else {
                            await db
                                .collection('usuarios')
                                .doc(user.uid)
                                .collection('favoritos')
                                .doc(missaoId)
                                .delete();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                novoFavorito
                                    ? '$nomeMissao foi adicionada aos favoritos.'
                                    : '$nomeMissao foi removida dos favoritos.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
