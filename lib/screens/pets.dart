import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:benjivet/models/pet.dart';
import 'informacoespet.dart';
import 'register.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Pet> petsCadastrados = [];

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  // 🔹 Carregar pets salvos no SharedPreferences
  Future<void> _carregarPets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonPets = prefs.getString('pets');

    if (jsonPets != null) {
      final List<dynamic> decoded = jsonDecode(jsonPets);
      setState(() {
        petsCadastrados = decoded.map((e) => Pet.fromJson(e)).toList();
      });
    }
  }

  // 🔹 Salvar lista de pets
  Future<void> _salvarPets() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonPets =
    jsonEncode(petsCadastrados.map((p) => p.toJson()).toList());
    await prefs.setString('pets', jsonPets);
  }

  // 🔹 Adicionar novo pet
  Future<void> adicionarPet() async {
    final novoPet = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );

    if (novoPet != null && novoPet is Pet) {
      setState(() {
        petsCadastrados.add(novoPet);
      });
      _salvarPets();
    }
  }

  IconData _iconePorEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case "cachorro":
        return Icons.pets;
      case "gato":
        return Icons.mood;
      case "passarinho":
        return Icons.air;
      default:
        return Icons.pets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pets"), centerTitle: true),
      body: petsCadastrados.isEmpty
          ? const Center(child: Text("Nenhum pet cadastrado"))
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: petsCadastrados.length,
        itemBuilder: (context, index) {
          final pet = petsCadastrados[index];
          return GestureDetector(
            onTap: () async {
              final petApagado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacoesPetScreen(pet: pet),
                ),
              );

              if (petApagado != null && petApagado is Pet) {
                setState(() {
                  petsCadastrados
                      .removeWhere((p) => p.id == petApagado.id);
                });
                _salvarPets();
              }
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    _iconePorEspecie(pet.especie),
                    size: 50,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pet.nome,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarPet,
        child: const Icon(Icons.add),
        tooltip: "Adicionar Pet",
      ),
    );
  }
}
