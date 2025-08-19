import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'dart:io';

class InformacoesPetScreen extends StatelessWidget {
  final Pet pet;

  const InformacoesPetScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.nome),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: pet.foto != null ? FileImage(pet.foto!) : null,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),

            Text(
              pet.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              "${pet.especie} - ${pet.raca}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text(
              "Idade: ${pet.idadeFormatada}",
              style: const TextStyle(fontSize: 18),
            ),

            Text(
              "Sexo: ${pet.sexo}",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            const Divider(),
            const Text(
              "Histórico Médico",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Nenhuma informação registrada ainda.",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
