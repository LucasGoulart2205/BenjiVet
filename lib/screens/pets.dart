import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'register.dart';
import 'informacoespet.dart';

class PetsScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final String token;

  const PetsScreen({super.key, required this.user, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pets"), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.8),
        itemCount: petsCadastrados.length,
        itemBuilder: (context, index) {
          final pet = petsCadastrados[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InformacoesPetScreen(pet: pet)));
            },
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: pet.foto != null ? DecorationImage(image: FileImage(pet.foto!), fit: BoxFit.cover) : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(pet.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
          (context as Element).reassemble();
        },
        child: const Icon(Icons.add),
        tooltip: "Adicionar Pet",
      ),
    );
  }
}
