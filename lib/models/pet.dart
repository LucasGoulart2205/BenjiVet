import 'dart:io';

class Pet {
  final int? id;
  final String nome;
  final String especie;
  final String raca;
  final DateTime? dataNascimento;
  final String? sexo;
  final int? idade; // quando vier direto do backend
  final int? tutorId;
  final File? foto;

  Pet({
    this.id,
    required this.nome,
    required this.especie,
    required this.raca,
    this.dataNascimento,
    this.sexo,
    this.idade,
    this.tutorId,
    this.foto,
  });

  /// Calcula idade formatada (quando tiver dataNascimento)
  String get idadeFormatada {
    if (dataNascimento == null) {
      return idade != null ? "$idade ano${idade! > 1 ? 's' : ''}" : "Não informado";
    }

    final hoje = DateTime.now();
    int anos = hoje.year - dataNascimento!.year;
    int meses = hoje.month - dataNascimento!.month;
    int dias = hoje.day - dataNascimento!.day;

    if (meses < 0 || (meses == 0 && dias < 0)) {
      anos--;
      meses += 12;
    }

    if (anos > 0) {
      return "$anos ano${anos > 1 ? 's' : ''}";
    } else if (meses > 0) {
      return "$meses mês${meses > 1 ? 'es' : ''}";
    } else {
      return "$dias dia${dias > 1 ? 's' : ''}";
    }
  }

  /// Construtor para criar Pet a partir de JSON
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'] ?? '',
      idade: json['idade'],
      tutorId: json['tutor_id'],
      sexo: json['sexo'],
    );
  }

  /// Converter Pet para JSON (para enviar ao backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'tutor_id': tutorId,
      'sexo': sexo,
    };
  }
}
