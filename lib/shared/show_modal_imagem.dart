import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitwayapp/repository/crop_imagem_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ShowModalImagem extends StatefulWidget {
  final User user;
  const ShowModalImagem({super.key, required this.user});

  @override
  State<ShowModalImagem> createState() => _ShowModalImagemState();
}

class _ShowModalImagemState extends State<ShowModalImagem> {
  var cropImage = CropImageRepository();
  adicionarFoto(ImageSource sorce) async {
    var db = FirebaseFirestore.instance;
    XFile? photo;

    final imagePicker = ImagePicker();

    photo = await imagePicker.pickImage(source: sorce);

    if (photo != null) {
      cropImage.cropImage(photo);
      Reference storage = FirebaseStorage.instance.ref().child(
          'img_perfil/${widget.user.uid}/${DateTime.now().millisecondsSinceEpoch}.png');
      await storage.putFile(File(photo.path));
      String downloadUrl = await storage.getDownloadURL();
      await db
          .collection('usuarios')
          .doc(widget.user.uid)
          .update({'foto': downloadUrl});
      await widget.user.updatePhotoURL(downloadUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          title: const Text("Camera"),
          leading: const FaIcon(FontAwesomeIcons.camera),
          onTap: () {
            adicionarFoto(ImageSource.camera);
          },
        ),
        ListTile(
          title: const Text("Galeria"),
          leading: const FaIcon(FontAwesomeIcons.image),
          onTap: () {
            adicionarFoto(ImageSource.gallery);
          },
        ),
        ListTile(
          title: const Text("Remover"),
          leading: const FaIcon(FontAwesomeIcons.xmark),
          onTap: () {},
        )
      ],
    );
  }
}
