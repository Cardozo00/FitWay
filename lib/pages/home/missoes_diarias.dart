import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/repository/missao_diaria_repository.dart';
import 'package:flutter/material.dart';

class ExercicioPage extends StatefulWidget {
  final User user;
  const ExercicioPage({super.key, required this.user});

  @override
  State<ExercicioPage> createState() => _ExercicioPageState();
}

class _ExercicioPageState extends State<ExercicioPage> {
  late bool fezMissao;
  List<Map<String, dynamic>> missaoDoDia = [];
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    fezMissao = false;
    db = FirebaseFirestore.instance;
    _carregarMissoesDoDia(); // Carregar as missões do dia
  }

  Future<void> _carregarMissoesDoDia() async {
    var missoesDoc = await db
        .collection('usuarios')
        .doc(widget.user.uid)
        .collection('missoes')
        .doc('missoes_do_dia')
        .get();

    var hoje = DateTime.now();

    if (missoesDoc.exists) {
      var data = missoesDoc.data();
      var dataMissao = (data?['data'] as Timestamp?)?.toDate();

      if (dataMissao != null &&
          dataMissao.year == hoje.year &&
          dataMissao.month == hoje.month &&
          dataMissao.day == hoje.day) {
        setState(() {
          var missoes = data?['missoes'];
          if (missoes is List) {
            missaoDoDia =
                List<Map<String, dynamic>>.from(missoes).map((missao) {
              return {
                ...missao,
                'concluida': missao['concluida'] ?? false,
                'favorito': missao['favorito'] ?? false,
              };
            }).toList();
          }
        });
        return;
      }
    }

    // Gerar novas missões se nenhuma foi definida hoje
    var listaMissoes = MissaoDiariaRepository().retornarMissoesDiarias();
    var novasMissoes = (listaMissoes..shuffle()).take(3).map((missao) {
      return {
        ...missao,
        'concluida': false,
        'favorito': false,
      };
    }).toList();

    await db
        .collection('usuarios')
        .doc(widget.user.uid)
        .collection('missoes')
        .doc('missoes_do_dia')
        .set({
      'missoes': novasMissoes,
      'data': Timestamp.now(),
    });

    setState(() {
      missaoDoDia = novasMissoes;
    });
  }

  Future<void> _toggleFavorito(Map<String, dynamic> missao) async {
    bool isFavorito = missao['favorito'] ?? false;

    try {
      // Atualizar diretamente o campo 'favorito' no documento de missoes_do_dia
      await db
          .collection('usuarios')
          .doc(widget.user.uid)
          .collection('missoes')
          .doc('missoes_do_dia')
          .update({
        'missoes': FieldValue.arrayRemove([missao]), // Remove a missão do array
      });

      // Agora, altere apenas o campo 'favorito' para o valor oposto
      var missaoAtualizada = {
        ...missao,
        'favorito': !isFavorito, // Inverte o valor de 'favorito'
      };

      // Atualiza a missão no array com o campo 'favorito' alterado
      await db
          .collection('usuarios')
          .doc(widget.user.uid)
          .collection('missoes')
          .doc('missoes_do_dia')
          .update({
        'missoes': FieldValue.arrayUnion(
            [missaoAtualizada]), // Adiciona a missão atualizada
      });

      // Se a missão for favoritada, adicione-a à coleção de favoritos
      if (!isFavorito) {
        await db
            .collection('usuarios')
            .doc(widget.user.uid)
            .collection('favoritos')
            .doc(missao['id'])
            .set({
          'id': missao['id'],
          'nome': missao['nome'],
          'data': Timestamp.now(),
        });
      } else {
        // Caso o usuário tenha desfavoritado, remova a missão da coleção de favoritos
        await db
            .collection('usuarios')
            .doc(widget.user.uid)
            .collection('favoritos')
            .doc(missao['id'])
            .delete();
      }

      setState(() {
        missao['favorito'] = !isFavorito; // Atualiza o estado local
      });
    } catch (e) {
      print("Erro ao atualizar favorito: $e");
    }
  }

  Future<void> _mostrarConfirmacao(
      BuildContext context, Map<String, dynamic> missao) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Concluir Missão"),
          content: Text(
              "Você tem certeza de que concluiu a missão '${missao['nome']}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Retorna false
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Retorna true
              },
              child: const Text("Concluir"),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _marcarMissaoComoConcluida(missao['id']);
    }
  }

  Future<void> _adicionarHistoricoMissao(Map<String, dynamic> missao) async {
    try {
      // Adiciona a missão concluída ao histórico
      await db
          .collection('usuarios')
          .doc(widget.user.uid)
          .collection('historico_missoes')
          .add({
        'id': missao['id'],
        'nome': missao['nome'],
        'data': Timestamp.now(),
        'concluida': true,
      });

      // Aqui, você pode fazer qualquer outra ação após a missão ser salva no histórico
      print("Missão concluída adicionada ao histórico");
    } catch (e) {
      print("Erro ao adicionar missão ao histórico: $e");
    }
  }

  Future<void> _marcarMissaoComoConcluida(String missaoId) async {
    var index = missaoDoDia.indexWhere((missao) => missao['id'] == missaoId);

    if (index != -1) {
      // Marcar a missão como concluída
      await db
          .collection('usuarios')
          .doc(widget.user.uid)
          .collection('missoes')
          .doc('missoes_do_dia')
          .update({
        'missoes': missaoDoDia.map((missao) {
          if (missao['id'] == missaoId) {
            return {...missao, 'concluida': true};
          }
          return missao;
        }).toList(),
      });

      // Atualizar pontos do usuário
      await db.collection('usuarios').doc(widget.user.uid).update({
        'totalPontos': FieldValue.increment(10),
      });

      setState(() {
        missaoDoDia[index]['concluida'] = true;
      });

      // Adicionar a missão concluída ao histórico
      await _adicionarHistoricoMissao(missaoDoDia[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Missões diárias",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        ...missaoDoDia.map((missao) {
          bool concluida = missao['concluida'] ?? false;
          return Card(
            color: concluida ? Colors.grey[300] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: concluida,
                        onChanged: concluida
                            ? null
                            : (value) {
                                if (value == true) {
                                  _mostrarConfirmacao(context, missao);
                                }
                              },
                      ),
                      Text(
                        missao['nome'] ?? "Missão indisponível",
                        style: TextStyle(
                          color: concluida ? Colors.grey : Colors.black,
                          decoration:
                              concluida ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await _toggleFavorito(missao);
                    },
                    icon: (missao['favorito'] ?? false)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
