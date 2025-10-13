import 'package:flutter/material.dart';
import 'package:benjivet/models/pet.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  String? especieSelecionada;
  String? sexoSelecionado;

  void cadastrarPet() {
    final pet = Pet(
      nome: nomeController.text,
      especie: especieSelecionada ?? "",
      raca: racaController.text,
      sexo: sexoSelecionado,
      dataNascimento:
      DateTime.tryParse(dataController.text) ?? DateTime.now(),
    );
    Navigator.pop(context, pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Pet"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título estilizado
            const Text(
              "Novo Pet",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Nome
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown para espécie
            DropdownButtonFormField<String>(
              value: especieSelecionada,
              decoration: InputDecoration(
                labelText: "Espécie",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items: const [
                DropdownMenuItem(value: "Cachorro", child: Text("Cachorro")),
                DropdownMenuItem(value: "Gato", child: Text("Gato")),
                DropdownMenuItem(value: "Passarinho", child: Text("Passarinho")),
              ],
              onChanged: (value) {
                setState(() {
                  especieSelecionada = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Raça
            TextField(
              controller: racaController,
              decoration: InputDecoration(
                labelText: "Raça",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown para sexo
            DropdownButtonFormField<String>(
              value: sexoSelecionado,
              decoration: InputDecoration(
                labelText: "Sexo",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              items: const [
                DropdownMenuItem(value: "Macho", child: Text("Macho")),
                DropdownMenuItem(value: "Fêmea", child: Text("Fêmea")),
              ],
              onChanged: (value) {
                setState(() {
                  sexoSelecionado = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Data de nascimento
            TextField(
              controller: dataController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Data de Nascimento",
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: const Locale("pt", "BR"),
                );

                if (pickedDate != null) {
                  setState(() {
                    dataController.text =
                    "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 30),

            // Botão de cadastro
            ElevatedButton(
              onPressed: cadastrarPet,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Cadastrar",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
