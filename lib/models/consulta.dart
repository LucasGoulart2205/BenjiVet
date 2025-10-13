class Consulta {
  final String nome;
  final DateTime data;
  final String? observacao;

  Consulta({
    required this.nome,
    required this.data,
    this.observacao,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
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
