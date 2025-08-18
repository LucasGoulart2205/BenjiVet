import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'pets.dart';

List<Pet> petsCadastrados = [];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Pet"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do Pet"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, digite o nome do pet";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Idade"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite a idade";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(labelText: "Espécie"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite a espécie do pet";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final novoPet = Pet(
                        nome: _nomeController.text,
                        idade: int.parse(_idadeController.text),
                        especie: _especieController.text,
                      );

                      petsCadastrados.add(novoPet);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pet cadastrado com sucesso!")),
                      );

                      _nomeController.clear();
                      _idadeController.clear();
                      _especieController.clear();
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PetsScreen()),
                    );
                  },
                  child: const Text("Ver meus pets"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
