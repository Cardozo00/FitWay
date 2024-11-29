import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/pages_conf/parceiros/parceiros.dart';
import 'package:fitwayapp/repository/cupons_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CuponsPage extends StatefulWidget {
  final User userId; // ID do usuário

  const CuponsPage({super.key, required this.userId});

  @override
  State<CuponsPage> createState() => _CuponsPageState();
}

class _CuponsPageState extends State<CuponsPage> {
  final _cuponsRepository = CuponsRepository();
  int _totalPontos = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalPontos();
  }

  Future<void> _fetchTotalPontos() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(widget.userId.uid)
          .get();
      setState(() {
        _totalPontos = snapshot.data()?['totalPontos'] ?? 0;
      });
    } catch (e) {
      print("Erro ao buscar pontos do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cupons"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RichText(
                text: TextSpan(
                  text: "Os cupons são disponíveis para uso com os nossos ",
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: "parceiros",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ParceirosPage(),
                            ),
                          );
                        },
                    ),
                    const TextSpan(
                      text: ".",
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _cuponsRepository.coupons.length,
                itemBuilder: (context, index) {
                  final cupom = _cuponsRepository.coupons[index];
                  final int pontosNecessarios =
                      (index + 1) * 100; // Exemplo: 100, 200, 300...

                  bool desbloqueado = _totalPontos >= pontosNecessarios;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: desbloqueado
                        ? ListTile(
                            title: Text(
                              cupom["code"]!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(cupom["description"]!),
                          )
                        : Container(
                            height: 80,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                FontAwesomeIcons.lock,
                                size: 30,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
