import 'dart:io';

class Pet {
  final String nome;
  final String especie;
  final String raca;
  final DateTime dataNascimento;
  final String sexo;
  final File? foto;

  Pet({
    required this.nome,
    required this.especie,
    required this.raca,
    required this.dataNascimento,
    required this.sexo,
    this.foto,
  });

  String get idadeFormatada {
    final hoje = DateTime.now();
    int anos = hoje.year - dataNascimento.year;
    int meses = hoje.month - dataNascimento.month;
    int dias = hoje.day - dataNascimento.day;

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
}
