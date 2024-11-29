import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/usuario/usuario.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/dados_pessoais/dados_pessoais.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/favoritos/favoritos.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/historico/historico.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/parceiros/parceiros.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/seguranca/seguranca.dart';
import 'package:fitwayapp/pages/login/login_page.dart';
import 'package:fitwayapp/repository/autenticacao/autenticacao_cadastro.dart';
import 'package:fitwayapp/shared/inkwell_configuracao.dart';
import 'package:fitwayapp/shared/show_modal_imagem.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfiguracoesPage extends StatefulWidget {
  final User user;
  const ConfiguracoesPage({super.key, required this.user});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final _autenticacao = AutenticacaoCadastro();
  var db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: db.collection('usuarios').doc(widget.user.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                var usuarioModal = UsuarioModel.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                  radius: 70,
                                  child: usuarioModal.foto.isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          size: 55,
                                        )
                                      : ClipOval(
                                          child: Image.network(
                                              width: 140,
                                              height: 140,
                                              fit: BoxFit.cover,
                                              usuarioModal.foto),
                                        )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (_) => ShowModalImagem(
                                              user: widget.user,
                                            ));
                                  },
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xff0A6D92),
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.user.displayName}",
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          inkwellConfiguracao(
                              context: context,
                              text: "Dados da conta",
                              widget: DadosPessoais(
                                user: widget.user,
                              ),
                              icon: FontAwesomeIcons.solidUser,
                              subtitle: 'Minhas informações da conta'),
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 105, 105, 105),
                          ),
                          inkwellConfiguracao(
                              context: context,
                              text: "Segurança",
                              widget: Seguranca(
                                user: widget.user,
                              ),
                              icon: FontAwesomeIcons.shield,
                              subtitle: 'Trocar senha'),
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 105, 105, 105),
                          ),
                          inkwellConfiguracao(
                              context: context,
                              text: "Favoritos",
                              widget: FavoritosPage(
                                user: widget.user,
                              ),
                              icon: FontAwesomeIcons.heart,
                              subtitle: 'Minhas atividades favoritas'),
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 105, 105, 105),
                          ),
                          inkwellConfiguracao(
                              context: context,
                              text: "Histórico",
                              widget: HistoricoPage(
                                user: widget.user,
                              ),
                              icon: FontAwesomeIcons.book,
                              subtitle: 'Histórico de atividades'),
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 105, 105, 105),
                          ),
                          inkwellConfiguracao(
                              context: context,
                              text: "Parceiros",
                              widget: const ParceirosPage(),
                              icon: FontAwesomeIcons.dumbbell,
                              subtitle:
                                  'Lojas, personais e nutricionistas parceiros'),
                          const Divider(
                            thickness: 1.5,
                            color: Color.fromARGB(255, 105, 105, 105),
                          ),
                        ],
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: inkwellConfiguracao(
                          context: context,
                          text: "Sair",
                          widget: const TelaLogin(
                            user: null,
                          ),
                          icon: FontAwesomeIcons.rightToBracket,
                          user: () => _autenticacao.deslogarUsuario()),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
