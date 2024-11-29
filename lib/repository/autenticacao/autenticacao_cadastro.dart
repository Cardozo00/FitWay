import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitwayapp/model/usuario/usuario.dart';
import 'package:fitwayapp/pages/home/formulario_avalicao.dart';
import 'package:fitwayapp/pages/tela_inical/tela_inical.dart';
import 'package:flutter/material.dart';

class AutenticacaoCadastro {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> autenticacaoCadastro(
      {required BuildContext context,
      required String email,
      required String senha,
      required String nome}) async {
    try {
      UserCredential userAuth = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      await userAuth.user!.updateDisplayName(nome);
      UsuarioModel usuarioModel = UsuarioModel(
          name: nome, email: email, senha: senha, foto: '', totalPontos: 0);
      await _db
          .collection('usuarios')
          .doc(userAuth.user!.uid)
          .set(usuarioModel.toJson());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FormularioAvalicao(user: userAuth.user!)));
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email ja cadastrado";
      }
      return "erro desconhecido";
    }
  }

  Future<String?> autenticacaoLogin(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    try {
      UserCredential userAuth1 = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TelaInical(
                    user: userAuth1.user!,
                  )));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> deslogarUsuario() {
    return _firebaseAuth.signOut();
  }
}
