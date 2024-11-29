import 'package:firebase_auth/firebase_auth.dart';

import 'package:fitwayapp/repository/autenticacao/autenticacao_cadastro.dart';
import 'package:fitwayapp/shared/input_decoration.dart';
import 'package:fitwayapp/shared/mostrar_snack_bar/mostrar_snack_bar.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  final User? user;
  const TelaLogin({super.key, required this.user});
  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _globalKey = GlobalKey<FormState>();
  final _autenticacao = AutenticacaoCadastro();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confSenhaController = TextEditingController();
  UserCredential? userAuth;

  bool cadastro = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff0A6D92),
        body: FocusScope(
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Image.asset(
                            "lib/imagens/logo.jpg",
                            height: 250,
                          ),
                        ),
                        Visibility(
                          visible: !cadastro,
                          child: TextFormFieldLogin(
                              label: 'Nome Completo',
                              textController: nomeController,
                              password: false,
                              login: true),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormFieldLogin(
                            label: 'E-mail',
                            textController: emailController,
                            password: false,
                            login: true),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormFieldLogin(
                            label: 'Senha',
                            textController: senhaController,
                            password: true,
                            login: true),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: !cadastro,
                          child: TextFormFieldLogin(
                            label: 'Confimar Senha',
                            textController: confSenhaController,
                            password: true,
                            login: true,
                          ),
                        ),
                        Visibility(
                          visible: !cadastro,
                          child: const SizedBox(
                            height: 10,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color.fromRGBO(255, 255, 255, 1)),
                                  shape:
                                      WidgetStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  )),
                              onPressed: () async {
                                botaoPrincipal();
                              },
                              child: Text(
                                (cadastro) ? "ENTRAR" : "CADASTRAR-SE",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                cadastro = !cadastro;
                              });
                            },
                            child: Text(
                              (cadastro)
                                  ? "Ainda não tem uma conta? Cadastre-se"
                                  : "Já tem uma conta? Entrar",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  botaoPrincipal() {
    if (_globalKey.currentState!.validate()) {
      if (cadastro) {
        _autenticacao
            .autenticacaoLogin(
                email: emailController.text,
                senha: senhaController.text,
                context: context)
            .then((String? erro) {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
          }
        });
      } else {
        _autenticacao
            .autenticacaoCadastro(
                email: emailController.text,
                senha: senhaController.text,
                nome: nomeController.text,
                context: context)
            .then((String? erro) async {
          if (erro != null) {
            mostrarSnackBar(context: context, texto: erro);
            return;
          }
        });
      }
      print("Form valido");
    } else {
      print("Form invalido");
    }
  }
}
