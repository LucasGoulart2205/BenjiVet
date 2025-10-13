import 'dart:io';
import 'vacina.dart';
import 'remedio.dart';
import 'consulta.dart';

class Pet {
  final int? id;
  final String nome;
  final String especie;
  final String raca;
  final DateTime? dataNascimento;
  final String? sexo;
  final int? idade;
  final int? tutorId;
  final File? foto;
  final List<Vacina> vacinas;
  final List<Remedio> remedios;
  final List<Consulta> consultas;

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
    List<Vacina>? vacinas,
    List<Remedio>? remedios,
    List<Consulta>? consultas,
  })  : vacinas = vacinas ?? [],
        remedios = remedios ?? [],
        consultas = consultas ?? [];

  String get idadeFormatada {
    if (dataNascimento == null) {
      return idade != null
          ? "$idade ano${idade! > 1 ? 's' : ''}"
          : "Não informado";
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

  // ✅ Conversão de JSON para Pet
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'] ?? '',
      idade: json['idade'],
      tutorId: json['tutor_id'],
      sexo: json['sexo'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.tryParse(json['dataNascimento'])
          : null,
      foto: json['fotoPath'] != null ? File(json['fotoPath']) : null,
      vacinas: (json['vacinas'] as List<dynamic>?)
          ?.map((v) => Vacina.fromJson(v))
          .toList() ??
          [],
      remedios: (json['remedios'] as List<dynamic>?)
          ?.map((r) => Remedio.fromJson(r))
          .toList() ??
          [],
      consultas: (json['consultas'] as List<dynamic>?)
          ?.map((c) => Consulta.fromJson(c))
          .toList() ??
          [],
    );
  }

  // ✅ Conversão de Pet para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'tutor_id': tutorId,
      'sexo': sexo,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'fotoPath': foto?.path, // salva apenas o caminho da imagem
      'vacinas': vacinas.map((v) => v.toJson()).toList(),
      'remedios': remedios.map((r) => r.toJson()).toList(),
      'consultas': consultas.map((c) => c.toJson()).toList(),
    };
  }
}
