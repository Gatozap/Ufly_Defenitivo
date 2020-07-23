class Carro{
  String foto;
  String modelo;
  String categoria;

  Carro({this.foto, this.modelo, this.categoria});

  @override
  String toString() {
    return 'Carro{foto: $foto, modelo: $modelo, categoria: $categoria}';
  }

  Carro.fromJson(Map<String, dynamic> json)
      : foto = json['foto'],
        modelo = json['modelo'],
        categoria = json['categoria'];

  Map<String, dynamic> toJson() => {
        'foto': foto,
        'modelo': modelo,
        'categoria': categoria,
      };
}