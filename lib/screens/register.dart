import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'pets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

List<Pet> petsCadastrados = [];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _especieController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();

  DateTime? _dataNascimento;
  String? _sexo;
  File? _imagemPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Pet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            _imagemPet = File(pickedImage.path);
                          });
                        }
                      },
                      child: const Text("Escolher Foto do Pet"),
                    ),
                    const SizedBox(height: 8),
                    if (_imagemPet != null)
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_imagemPet!),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

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
                controller: _especieController,
                decoration: const InputDecoration(labelText: "Espécie (Gato, Cachorro...)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite a espécie do pet";
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _racaController,
                decoration: const InputDecoration(labelText: "Raça"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite a raça do pet";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(labelText: "Sexo"),
                items: const [
                  DropdownMenuItem(value: "Macho", child: Text("Macho")),
                  DropdownMenuItem(value: "Fêmea", child: Text("Fêmea")),
                ],
                onChanged: (value) {
                  setState(() {
                    _sexo = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Selecione o sexo do pet";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Data de Nascimento",
                  hintText: _dataNascimento != null
                      ? "${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}"
                      : "Selecione a data",
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dataNascimento = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (_dataNascimento == null) {
                    return "Selecione a data de nascimento";
                  }
                  return null;
                },
              ),


              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _dataNascimento != null) {
                      final novoPet = Pet(
                        nome: _nomeController.text,
                        especie: _especieController.text,
                        raca: _racaController.text,
                        dataNascimento: _dataNascimento!,
                        sexo: _sexo!,
                        foto: _imagemPet,
                      );

                      petsCadastrados.add(novoPet);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pet cadastrado com sucesso!")),
                      );


                      _nomeController.clear();
                      _especieController.clear();
                      _racaController.clear();
                      _sexo = null;
                      _dataNascimento = null;
                      _imagemPet = null;


                      Navigator.pop(context);
                    } else if (_dataNascimento == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Selecione a data de nascimento")),
                      );
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
