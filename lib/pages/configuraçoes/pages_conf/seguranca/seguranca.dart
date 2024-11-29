import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/usuario/usuario.dart';
import 'package:fitwayapp/shared/input_decoration.dart';
import 'package:flutter/material.dart';

class Seguranca extends StatelessWidget {
  final User user;
  const Seguranca({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    TextEditingController senhaAntiga = TextEditingController();
    TextEditingController novaSenha = TextEditingController();
    TextEditingController confirSenha = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segurança'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<DocumentSnapshot>(
            stream: db.collection('usuarios').doc(user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var userAccount = UsuarioModel.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Senha antiga',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormFieldLogin(
                      label: '*' * (userAccount.senha.length),
                      password: false,
                      textController: senhaAntiga,
                      login: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Nova Senha',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormFieldLogin(
                        label: 'Senha',
                        textController: novaSenha,
                        password: true,
                        login: false),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormFieldLogin(
                      label: "Confirmar senha",
                      password: true,
                      textController: confirSenha,
                      login: false,
                    ),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  const Color(0xff0A6D92)),
                              shape: WidgetStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              )),
                          onPressed: () async {
                            try {
                              if (novaSenha.text.isEmpty ||
                                  confirSenha.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Preencha todos os campos.")),
                                );
                                return;
                              }

                              if (novaSenha.text != confirSenha.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("As senhas não coincidem.")),
                                );
                                return;
                              }

                              user.updatePassword(novaSenha.text);

                              await db
                                  .collection('usuarios')
                                  .doc(user.uid)
                                  .update({
                                'senha': novaSenha.text,
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Senha atualizada com sucesso!")),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Erro: ${e.toString()}")),
                              );
                            }
                          },
                          child: const Text(
                            'Atualizar senha',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
