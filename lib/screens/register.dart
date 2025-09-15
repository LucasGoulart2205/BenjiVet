import 'package:flutter/material.dart';
import 'package:benjivet/models/pet.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  final String token;

  const RegisterScreen({super.key, required this.token});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController especieController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  Future<void> cadastrarPet() async {
    final url = Uri.parse("http://10.0.2.2:5000/pets");
    final body = {
      "nome": nomeController.text,
      "especie": especieController.text,
      "raca": racaController.text,
      "sexo": sexoController.text,
      "dataNascimento": dataController.text,
    };

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final pet = Pet(
        nome: nomeController.text,
        especie: especieController.text,
        raca: racaController.text,
        sexo: sexoController.text,
        dataNascimento: DateTime.tryParse(dataController.text) ?? DateTime.now(),
      );
      Navigator.pop(context, pet);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao cadastrar pet")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Pet"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: especieController,
                decoration: const InputDecoration(labelText: "Espécie"),
              ),
              TextField(
                controller: racaController,
                decoration: const InputDecoration(labelText: "Raça"),
              ),
              TextField(
                controller: sexoController,
                decoration: const InputDecoration(labelText: "Sexo"),
              ),
              TextField(
                controller: dataController,
                decoration: const InputDecoration(labelText: "Data Nascimento (yyyy-mm-dd)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: cadastrarPet,
                child: const Text("Cadastrar Pet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
