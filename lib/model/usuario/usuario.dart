class UsuarioModel {
  String name="";
  String email = "";
  String senha="";
  String foto = "";
  int totalPontos= 0;

  UsuarioModel({ required this.name, required this.email, required this.senha,required this.foto, required this.totalPontos});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    senha = json['senha'];
    foto = json['foto'];
    totalPontos = json['totalPontos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['senha'] = senha;
    data['foto'] = foto;
    data['totalPontos'] = totalPontos;
    return data;
  }
}
