import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/formulario_model/formulario_model.dart';
import 'package:fitwayapp/shared/input_decoration.dart';
import 'package:flutter/material.dart';

class DadosPessoais extends StatelessWidget {
  final User user;
  const DadosPessoais({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var nomeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('DADOS DA CONTA'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: db
              .collection('usuarios')
              .doc(user.uid)
              .collection('formulario')
              .doc('form')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var formularioModel = FormularioModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);
              var imc =
                  snapshot.data!.get('imc'); // Recupera o IMC do Firestore

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações pessoais',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Nome",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${user.displayName}",
                          password: false,
                          textController: nomeController,
                          login: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "E-mail",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${user.email}",
                          password: false,
                          textController: nomeController,
                          login: false,
                          somenteLer: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Informações formulário',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Idade",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${formularioModel.idade} anos",
                          password: false,
                          textController: nomeController,
                          login: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Peso",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${formularioModel.peso} Kg",
                          password: false,
                          textController: nomeController,
                          login: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Altura",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${formularioModel.altura} m",
                          password: false,
                          textController: nomeController,
                          login: false,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Sexo",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: "${formularioModel.sexo}",
                          password: false,
                          textController: nomeController,
                          login: false,
                          somenteLer: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "IMC",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        TextFormFieldLogin(
                          label: imc != null ? "$imc" : "Não disponível",
                          password: false,
                          textController: nomeController,
                          login: false,
                          somenteLer: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color(0xff0A6D92)),
                                shape: WidgetStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                )),
                            child: const Text(
                              "Atualizar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
