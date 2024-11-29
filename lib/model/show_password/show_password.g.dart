// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_password.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ShowPassword on Password, Store {
  late final _$showPasswordAtom =
      Atom(name: 'Password.showPassword', context: context);

  @override
  bool get showPassword {
    _$showPasswordAtom.reportRead();
    return super.showPassword;
  }

  @override
  set showPassword(bool value) {
    _$showPasswordAtom.reportWrite(value, super.showPassword, () {
      super.showPassword = value;
    });
  }

  late final _$PasswordActionController =
      ActionController(name: 'Password', context: context);

  @override
  void mostrarSenha() {
    final _$actionInfo =
        _$PasswordActionController.startAction(name: 'Password.mostrarSenha');
    try {
      return super.mostrarSenha();
    } finally {
      _$PasswordActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showPassword: ${showPassword}
    ''';
  }
}
