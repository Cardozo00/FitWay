class FormularioModel {
  // int? id;
  String? peso;
  String? altura;
  String? idade;
  String? sexo;

  FormularioModel(
      {
      // required this.id,
      required this.peso,
      required this.altura,
      required this.idade,
      required this.sexo});

  FormularioModel.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    peso = json['peso'];
    altura = json['altura'];
    idade = json['idade'];
    sexo = json['sexo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['id'] = id;
    data['peso'] = peso;
    data['altura'] = altura;
    data['idade'] = idade;
    data['sexo'] = sexo;
    return data;
  }
}
