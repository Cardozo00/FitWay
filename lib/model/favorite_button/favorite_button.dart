import 'package:mobx/mobx.dart';

part 'favorite_button.g.dart';

class FavoriteButtons = FavoriteButton with _$FavoriteButtons;

abstract class FavoriteButton with Store {
  @observable
  bool favoriteButton = false;

  @action
  void favoritar() {
    favoriteButton = !favoriteButton;
  }
}
