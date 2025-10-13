import 'package:flutter/material.dart';
import 'package:benjivet/models/pet.dart';
import 'package:benjivet/models/vacina.dart';
import 'package:benjivet/models/remedio.dart';
import 'package:benjivet/models/consulta.dart';
import 'package:benjivet/services/notification_service.dart'; // ✅ importa o serviço de notificações

class InformacoesPetScreen extends StatefulWidget {
  final Pet pet;

  const InformacoesPetScreen({super.key, required this.pet});

  @override
  State<InformacoesPetScreen> createState() => _InformacoesPetScreenState();
}

class _InformacoesPetScreenState extends State<InformacoesPetScreen> {
  int _abaSelecionada = 0;

  IconData _iconePorEspecie(String especie) {
    switch (especie.toLowerCase()) {
      case "cachorro":
        return Icons.pets;
      case "gato":
        return Icons.pets_outlined;
      case "passarinho":
        return Icons.air;
      default:
        return Icons.pets;
    }
  }

  // ------------------- Vacina ------------------------------------------

  void _adicionarVacina() async {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController obsController = TextEditingController();
    DateTime? dataSelecionada;
    String? horarioSelecionado;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text(
              "Adicionar Vacina",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome da vacina",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: obsController,
                    decoration: InputDecoration(
                      labelText: "Observação",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo de data
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setStateDialog(() => dataSelecionada = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: dataSelecionada == null
                              ? "Data da vacina"
                              : "${dataSelecionada!.day.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.month.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.year}",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Campo de horário
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setStateDialog(() => horarioSelecionado =
                        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}");
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: horarioSelecionado == null
                              ? "Horário da vacina"
                              : horarioSelecionado,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.teal, foregroundColor: Colors.white),
                onPressed: () {
                  if (nomeController.text.isNotEmpty && dataSelecionada != null) {
                    final novaVacina = Vacina(
                      nome: nomeController.text,
                      data: dataSelecionada!,
                      horario: horarioSelecionado,
                      observacao: obsController.text,
                    );
                    setState(() => widget.pet.vacinas.add(novaVacina));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Preencha nome e data")));
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }

  // ------------------- Remédio ------------------------------------------

  void _adicionarRemedio() async {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController obsController = TextEditingController();
    DateTime? dataSelecionada;
    TimeOfDay? horaSelecionada;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Adicionar Remédio", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome do remédio",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: obsController,
                    decoration: InputDecoration(
                      labelText: "Observação",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Selecionar data
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setStateDialog(() => dataSelecionada = picked);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: dataSelecionada == null
                              ? "Data do remédio"
                              : "${dataSelecionada!.day.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.month.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.year}",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setStateDialog(() => horaSelecionada = picked);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: horaSelecionada == null
                              ? "Hora do remédio"
                              : "${horaSelecionada!.hour.toString().padLeft(2, '0')}:"
                              "${horaSelecionada!.minute.toString().padLeft(2, '0')}",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                onPressed: () {
                  if (nomeController.text.isNotEmpty && dataSelecionada != null && horaSelecionada != null) {
                    // Combina data e hora
                    final dataCompleta = DateTime(
                      dataSelecionada!.year,
                      dataSelecionada!.month,
                      dataSelecionada!.day,
                      horaSelecionada!.hour,
                      horaSelecionada!.minute,
                    );

                    final novoRemedio = Remedio(
                      nome: nomeController.text,
                      data: dataCompleta,
                      observacao: obsController.text,
                    );

                    setState(() => widget.pet.remedios.add(novoRemedio));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Preencha nome, data e hora")));
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }

  // ------------------- Consulta ------------------------------------------

  void _adicionarConsulta() async {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController obsController = TextEditingController();
    DateTime? dataSelecionada;
    TimeOfDay? horaSelecionada;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text(
              "Adicionar Consulta",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome da consulta",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: obsController,
                    decoration: InputDecoration(
                      labelText: "Observação",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Selecionar data
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setStateDialog(() => dataSelecionada = picked);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: dataSelecionada == null
                              ? "Data da consulta"
                              : "${dataSelecionada!.day.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.month.toString().padLeft(2, '0')}/"
                              "${dataSelecionada!.year}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Selecionar hora
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setStateDialog(() => horaSelecionada = picked);
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: horaSelecionada == null
                              ? "Hora da consulta"
                              : "${horaSelecionada!.hour.toString().padLeft(2, '0')}:"
                              "${horaSelecionada!.minute.toString().padLeft(2, '0')}",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (nomeController.text.isNotEmpty &&
                      dataSelecionada != null &&
                      horaSelecionada != null) {
                    final dataCompleta = DateTime(
                      dataSelecionada!.year,
                      dataSelecionada!.month,
                      dataSelecionada!.day,
                      horaSelecionada!.hour,
                      horaSelecionada!.minute,
                    );

                    final novaConsulta = Consulta(
                      nome: nomeController.text,
                      data: dataCompleta,
                      observacao: obsController.text,
                    );

                    setState(() => widget.pet.consultas.add(novaConsulta));

                    // ✅ AGENDAR NOTIFICAÇÃO NO HORÁRIO DA CONSULTA
                    await NotificationService().scheduleNotification(
                      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // id único
                      title: "Consulta de ${widget.pet.nome}",
                      body: "Hora da consulta: ${horaSelecionada!.hour.toString().padLeft(2,'0')}:${horaSelecionada!.minute.toString().padLeft(2,'0')}",
                      scheduledTime: dataCompleta,
                    );

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Consulta adicionada e notificação agendada para ${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preencha nome, data e hora")),
                    );
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        });
      },
    );
  }



  // ------------------- Telas ------------------------------------------

  Widget _telaInformacoes() {
    final pet = widget.pet;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[200],
            child: Icon(_iconePorEspecie(pet.especie), size: 70, color: Colors.teal),
          ),
          const SizedBox(height: 20),
          Text(pet.nome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 10),
          Text("${pet.especie} - ${pet.raca}",
              style: const TextStyle(fontSize: 18, color: Colors.black54)),
          const SizedBox(height: 25),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.cake, color: Colors.teal),
              title: const Text("Idade", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pet.idadeFormatada),
            ),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.male, color: Colors.teal),
              title: const Text("Sexo", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pet.sexo ?? "Não informado"),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Vacinas com separação (Futuras / Realizadas)
  Widget _telaVacinas() {
    final hoje = DateTime.now();
    final futuras = widget.pet.vacinas
        .where((v) => !v.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();
    final passadas = widget.pet.vacinas
        .where((v) => v.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();

    if (futuras.isEmpty && passadas.isEmpty) {
      return const Center(child: Text("Nenhuma vacina cadastrada"));
    }

    return _separadorListas("Vacinas futuras", futuras, Icons.vaccines, Colors.orange,
        "Vacinas realizadas", passadas, Icons.check_circle, Colors.green);
  }

  // 🔹 Remédios com separação (Futuros / Realizados)
  Widget _telaRemedios() {
    final hoje = DateTime.now();
    final futuras = widget.pet.remedios
        .where((r) => !r.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();
    final passadas = widget.pet.remedios
        .where((r) => r.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();

    if (futuras.isEmpty && passadas.isEmpty) {
      return const Center(child: Text("Nenhum remédio cadastrado"));
    }

    return _separadorListas("Remédios futuros", futuras, Icons.medication, Colors.orange,
        "Remédios realizados", passadas, Icons.check_circle, Colors.green);
  }

  // 🔹 Consultas com separação (Futuras / Realizadas)
  Widget _telaConsultas() {
    final hoje = DateTime.now();
    final futuras = widget.pet.consultas
        .where((c) => !c.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();
    final passadas = widget.pet.consultas
        .where((c) => c.data.isBefore(DateTime(hoje.year, hoje.month, hoje.day)))
        .toList();

    if (futuras.isEmpty && passadas.isEmpty) {
      return const Center(child: Text("Nenhuma consulta cadastrada"));
    }

    return _separadorListas("Consultas futuras", futuras, Icons.calendar_month, Colors.orange,
        "Consultas realizadas", passadas, Icons.check_circle, Colors.green);
  }

  // 🔹 Widget genérico pra listas separadas
  Widget _separadorListas(String titulo1, List lista1, IconData icone1, Color cor1,
      String titulo2, List lista2, IconData icone2, Color cor2) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (lista1.isNotEmpty) ...[
          Text(titulo1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...lista1.map((item) => _cardItem(item.nome, item.data, item.observacao, icone1, cor1)),
          const SizedBox(height: 16),
        ],
        if (lista2.isNotEmpty) ...[
          Text(titulo2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...lista2.map((item) => _cardItem(item.nome, item.data, item.observacao, icone2, cor2)),
        ],
      ]),
    );
  }

  // 🔹 Card genérico
  Widget _cardItem(String nome, DateTime data, String? obs, IconData icone, Color cor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icone, color: cor),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(
          "Data: ${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}\n"
              "Obs: ${obs?.isEmpty == true ? 'Nenhuma' : obs}",
        ),
      ),
    );
  }

  // ------------------- Build ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pet.nome), centerTitle: true),
      body: _abaSelecionada == 0
          ? _telaInformacoes()
          : _abaSelecionada == 1
          ? _telaVacinas()
          : _abaSelecionada == 2
          ? _telaRemedios()
          : _telaConsultas(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaSelecionada,
        onTap: (index) => setState(() => _abaSelecionada = index),
        selectedItemColor: Colors.teal,        // botão selecionado
        unselectedItemColor: Colors.grey, // botões não selecionados
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Informações"),
          BottomNavigationBarItem(icon: Icon(Icons.vaccines), label: "Vacinas"),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Remédios"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Consultas"),
        ],
      ),
      floatingActionButton: _abaSelecionada == 1
          ? FloatingActionButton(
        onPressed: _adicionarVacina,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : _abaSelecionada == 2
          ? FloatingActionButton(
        onPressed: _adicionarRemedio,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : _abaSelecionada == 3
          ? FloatingActionButton(
        onPressed: _adicionarConsulta,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}
