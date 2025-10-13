class Vacina {
  final String nome;
  final DateTime data;
  final String? horario; // agora é String
  final String? observacao;

  Vacina({
    required this.nome,
    required this.data,
    this.horario,
    this.observacao,
  });

  factory Vacina.fromJson(Map<String, dynamic> json) {
    return Vacina(
      nome: json['nome'] ?? '',
      data: DateTime.parse(json['data']),
      horario: json['horario'],
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'data': data.toIso8601String(),
      'horario': horario,
      'observacao': observacao,
    };
  }
}
