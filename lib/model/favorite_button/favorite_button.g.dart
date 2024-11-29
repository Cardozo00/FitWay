// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_button.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FavoriteButtons on FavoriteButton, Store {
  late final _$favoriteButtonAtom =
      Atom(name: 'FavoriteButton.favoriteButton', context: context);

  @override
  bool get favoriteButton {
    _$favoriteButtonAtom.reportRead();
    return super.favoriteButton;
  }

  @override
  set favoriteButton(bool value) {
    _$favoriteButtonAtom.reportWrite(value, super.favoriteButton, () {
      super.favoriteButton = value;
    });
  }

  late final _$FavoriteButtonActionController =
      ActionController(name: 'FavoriteButton', context: context);

  @override
  void favoritar() {
    final _$actionInfo = _$FavoriteButtonActionController.startAction(
        name: 'FavoriteButton.favoritar');
    try {
      return super.favoritar();
    } finally {
      _$FavoriteButtonActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
favoriteButton: ${favoriteButton}
    ''';
  }
}
