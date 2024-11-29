import 'package:fitwayapp/model/show_password/show_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// InputDecoration getAutenticationInputDecoration({required String label, bool? isObscure}) {
//   return InputDecoration(
//     contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//     hintText: label,
//     fillColor: Colors.white,
//     filled: true,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//     enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(13),
//         borderSide: const BorderSide(color: Colors.transparent)),
//     focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.black)),
//   );
// }

class TextFormFieldLogin extends StatelessWidget {
  final String label;
  final TextEditingController textController;
  final bool password;
  final bool login;
  final bool? somenteLer;
  const TextFormFieldLogin({
    super.key,
    required this.label,
    required this.textController,
    required this.password,
    required this.login,
    this.somenteLer,
  });

  @override
  Widget build(BuildContext context) {
    bool isObscure = true;
    final ShowPassword showPassword = ShowPassword();
    return Observer(
        builder: (_) => TextFormField(
            readOnly: somenteLer == true ? true : false,
            obscureText: password == true ? showPassword.showPassword : false,
            controller: textController,
            cursorColor: Colors.black,
            validator: (String? value) {
              switch (label) {
                case 'Nome Completo':
                  if (value == null) {
                    return "O nome não pode ser vazio";
                  }
                  if (value.length < 5) {
                    return "O nome muito curto";
                  }

                  break;
                case 'E-mail':
                  if (value == null) {
                    return "O e-mail não pode ser vazio";
                  }
                  if (value.length < 5) {
                    return "O e-mail é muito curto";
                  }
                  if (!value.contains("@")) {
                    return "O e-mail não é valido";
                  }
                  break;
                case 'Senha':
                  if (value == null) {
                    return "Senha inválida";
                  }
                  if (value.length < 6) {
                    return "Senha muito curta";
                  }
                  break;
                case 'Confimar Senha':
                  if (value == null) {
                    return "Senhas Diferentes";
                  }
                  if (value != textController.text) {
                    return "Senhas Difrentes";
                  }
                  break;
                default:
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: (password)
                  ? InkWell(
                      onTap: () {
                        showPassword.mostrarSenha();
                      },
                      child: isObscure == true
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off))
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              hintText: label,
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: login
                      ? const BorderSide(color: Colors.transparent)
                      : const BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black)),
            )));
  }
}
