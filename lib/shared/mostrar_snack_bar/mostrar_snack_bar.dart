import 'package:flutter/material.dart';

mostrarSnackBar({
  required BuildContext context,
  required String texto,
  bool isErro = true
}){
  SnackBar snackBar = SnackBar(content: Text(texto),
  duration: const Duration(seconds: 3),
  shape:const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(10))
  ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}