import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/pages/configura%C3%A7oes/configuracoes_page.dart';
import 'package:fitwayapp/pages/cupons/cupons_page.dart';
import 'package:fitwayapp/pages/home/home_page.dart';
import 'package:fitwayapp/pages/ranking/ranking_page.dart';
import 'package:flutter/material.dart';

class TelaInical extends StatefulWidget {
  final User user;
  const TelaInical({super.key, required this.user});

  @override
  State<TelaInical> createState() => _TelaInicalState();
}

class _TelaInicalState extends State<TelaInical> {
  PageController pageController = PageController(initialPage: 0);
  int posicaoPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              setState(() {
                posicaoPage = value;
              });
            },
            children: [
              HomePage(
                user: widget.user,
              ),
              RankingPage(
                user: widget.user,
              ),
              CuponsPage(
                userId: widget.user,
              ),
              ConfiguracoesPage(
                user: widget.user,
              )
            ],
          )),
          BottomNavigationBar(
              backgroundColor: const Color(0xff0A6D92),
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                setState(() {
                  pageController.jumpToPage(value);
                });
              },
              currentIndex: posicaoPage,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: "Ranking"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.discount), label: "Cupons"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Perfil",
                )
              ]),
        ],
      ),
    );
  }
}
