class Remedio {
  final String nome;
  final DateTime data;
  final String? observacao;

  Remedio({
    required this.nome,
    required this.data,
    this.observacao,
  });

  factory Remedio.fromJson(Map<String, dynamic> json) {
    return Remedio(
      nome: json['nome'] ?? '',
      data: DateTime.parse(json['data']),
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'data': data.toIso8601String(),
      'observacao': observacao,
    };
  }
}
