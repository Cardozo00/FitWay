import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/formulario_model/formulario_model.dart';
import 'package:fitwayapp/pages/tela_inical/tela_inical.dart';
import 'package:fitwayapp/shared/input_decoration.dart';
import 'package:flutter/material.dart';

class FormularioAvalicao extends StatefulWidget {
  final User user;
  const FormularioAvalicao({super.key, required this.user});

  @override
  State<FormularioAvalicao> createState() => _FormularioAvalicaoState();
}

class _FormularioAvalicaoState extends State<FormularioAvalicao> {
  var db = FirebaseFirestore.instance;
  var idadeController = TextEditingController();
  var pesoController = TextEditingController();
  var alturaController = TextEditingController();
  var sexoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A6D92),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: [
                            const Column(
                              children: [
                                Text(
                                  "Bem-vindo(a) 💪",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Estamos empolgados em ter você conosco! Antes de começarmos, precisamos de algumas informações para personalizar sua experiência e ajudá-lo(a) a alcançar seus objetivos. Lembre-se: cada passo conta e estamos aqui para apoiar você em cada um deles. Vamos juntos transformar sua motivação em resultados!",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormFieldLogin(
                                label: 'Idade',
                                textController: idadeController,
                                password: false,
                                login: false),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormFieldLogin(
                                label: 'Peso',
                                textController: pesoController,
                                password: false,
                                login: false),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormFieldLogin(
                                label: 'Altura (em metros)',
                                textController: alturaController,
                                password: false,
                                login: false),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: sexoController.text.isEmpty
                                          ? 'Sexo'
                                          : sexoController.text,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          if (newValue != 'Sexo') {
                                            sexoController.text = newValue!;
                                          }
                                        });
                                      },
                                      items: <String>[
                                        'Sexo',
                                        'Masculino',
                                        'Feminino'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff0A6D92),
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  // Cálculo do IMC
                                  double peso =
                                      double.tryParse(pesoController.text) ?? 0;
                                  double altura =
                                      double.tryParse(alturaController.text) ??
                                          0;

                                  if (peso <= 0 || altura <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Por favor, insira peso e altura válidos.'),
                                      ),
                                    );
                                    return;
                                  }

                                  double imc = peso / (altura * altura);

                                  // Salvar dados no Firestore
                                  var formularioModel = FormularioModel(
                                    altura: alturaController.text,
                                    peso: pesoController.text,
                                    idade: idadeController.text,
                                    sexo: sexoController.text,
                                  );
                                  await db
                                      .collection('usuarios')
                                      .doc(widget.user.uid)
                                      .collection('formulario')
                                      .doc("form")
                                      .set({
                                    ...formularioModel.toJson(),
                                    'imc': imc.toStringAsFixed(2), // IMC
                                  });

                                  _enviarFormulario(snapshot.data!);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void _enviarFormulario(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({'formularioPreenchido': true});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TelaInical(user: user)),
      );
    } catch (e) {
      print('Erro ao enviar formulário: $e');
    }
  }
}
