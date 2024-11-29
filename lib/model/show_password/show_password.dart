import 'package:mobx/mobx.dart';

part 'show_password.g.dart';

class ShowPassword = Password with _$ShowPassword;

abstract class Password with Store {
  @observable
  bool showPassword = true;

  @action
  void mostrarSenha() {
    showPassword = !showPassword;
  }
}
