import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'register.dart';
import 'informacoespet.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pets"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: petsCadastrados.length,
        itemBuilder: (context, index) {
          final pet = petsCadastrados[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(pet.nome),
              subtitle: Text("${pet.especie}, ${pet.idade} anos"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformacoesPetScreen(pet: pet),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
