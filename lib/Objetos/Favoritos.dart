class Favoritos{
  String local;
  String endereco;

  Favoritos({this.local, this.endereco});

  @override
  String toString() {
    return 'Favoritos{local: $local, endereco: $endereco}';
  }

  Favoritos.fromJson(Map<String, dynamic> json)
      : local = json['local'],
        endereco = json['endereco'];

  Map<String, dynamic> toJson() => {
        'local': local,
        'endereco': endereco,
      };
}