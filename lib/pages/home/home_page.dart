import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/usuario/usuario.dart';
import 'package:fitwayapp/pages/home/missoes_diarias.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
          stream: db.collection('usuarios').doc(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              var usuarioModel = UsuarioModel.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>);

              return Column(
                children: [
                  Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  child: usuarioModel.foto.isEmpty
                                      ? const Icon(Icons.person)
                                      : ClipOval(
                                          child: Image.network(
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              usuarioModel.foto),
                                        )),
                              const SizedBox(width: 15),
                              Text(
                                "Olá, ${(widget.user.displayName != null) ? widget.user.displayName : ""}",
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: ListView(
                        children: [
                          ExercicioPage(user: widget.user),
                          const SizedBox(height: 20),
                          const Text(
                            "Dicas para o seu dia a dia",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 7),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildCard(
                                  imageUrl:
                                      'lib/imagens/pessoa_fazendo_exercicio.jpg',
                                  title: 'Atividade Física',
                                  subtitle:
                                      'Exercitar-se 30 minutos por dia melhora o humor, reduz o estresse e previne doenças!',
                                ),
                                _buildCard(
                                  imageUrl: 'lib/imagens/alimento_saudavel.jpg',
                                  title: 'Alimentação Saudável',
                                  subtitle:
                                      'Coma mais frutas, legumes e verduras. Alimentos naturais são fontes de energia e saúde.',
                                ),
                                _buildCard(
                                  imageUrl:
                                      'lib/imagens/pessoa_bebendo_agua.jpg',
                                  title: 'Hidratação',
                                  subtitle:
                                      'Beber 2 litros de água por dia ajuda na digestão e na saúde da pele.',
                                ),
                                _buildCard(
                                  imageUrl: 'lib/imagens/pessoa_dormindo.png',
                                  title: 'Sono de Qualidade',
                                  subtitle:
                                      'Durma ao menos 7-8 horas por noite para recuperar suas energias!',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Vídeos Recomendados",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 7),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildVideoThumbnail(
                                  imageUrl: 'lib/imagens/montar_dieta.png',
                                  url: Uri.parse(
                                      'https://www.youtube.com/watch?v=wJBof_K85YY'),
                                ),
                                _buildVideoThumbnail(
                                  imageUrl: 'lib/imagens/10_habitos.png',
                                  url: Uri.parse(
                                      'https://www.youtube.com/watch?v=axoZk3sz50o'),
                                ),
                                _buildVideoThumbnail(
                                  imageUrl: 'lib/imagens/exercicios.png',
                                  url: Uri.parse(
                                      'https://www.youtube.com/watch?v=d1Lv5H1nDDw'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      child: Card(
        margin: const EdgeInsets.only(right: 10),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 200,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail({
    required String imageUrl,
    required Uri url,
  }) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageUrl,
            width: 150,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
