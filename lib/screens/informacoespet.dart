import 'package:flutter/material.dart';
import 'package:benjivet/models/pet.dart';

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
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.pets,
                size: 60,
                color: Colors.teal,
              ),
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
          ],
        ),
      ),
    );
  }
}
