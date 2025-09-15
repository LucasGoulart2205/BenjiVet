import 'package:flutter/material.dart';
import 'package:benjivet/models/pet.dart'; // Seu modelo Pet
import 'informacoespet.dart';
import 'register.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PetsScreen extends StatefulWidget {
  final String token;

  const PetsScreen({super.key, required this.token});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<Pet> petsCadastrados = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    setState(() => loading = true);
    try {
      final url = Uri.parse("http://10.0.2.2:5000/pets");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          petsCadastrados = data.map((petJson) {
            return Pet(
              nome: petJson['nome'] ?? "Sem nome",
              especie: petJson['especie'] ?? "Não informado",
              raca: petJson['raca'] ?? "Não informado",
              dataNascimento: DateTime.tryParse(petJson['dataNascimento'] ?? '') ?? DateTime.now(),
              sexo: petJson['sexo'] ?? "Não informado",
            );
          }).toList();
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar pets")),
      );
    }
  }

  Future<void> adicionarPet() async {
    final novoPet = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(token: widget.token),
      ),
    );

    if (novoPet != null && novoPet is Pet) {
      setState(() {
        petsCadastrados.add(novoPet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pets"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : petsCadastrados.isEmpty
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformacoesPetScreen(pet: pet),
                ),
              );
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
                  child: const Icon(
                    Icons.pets,
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
                Text(
                  "${pet.especie} - ${pet.idadeFormatada}",
                  style: const TextStyle(fontSize: 14),
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
