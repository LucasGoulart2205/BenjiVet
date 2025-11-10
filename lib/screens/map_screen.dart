import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-29.3333, -49.7266),
    zoom: 14,
  );

  final Set<Marker> _markers = {};

  // Função para mostrar diálogo e adicionar marcador
  void _showAddMarkerDialog(LatLng position) {
    final nomeController = TextEditingController();
    final racaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adicionar Pet"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: racaController,
              decoration: const InputDecoration(labelText: "Raça"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              final nome = nomeController.text;
              final raca = racaController.text;
              if (nome.isNotEmpty && raca.isNotEmpty) {
                _addMarker(position, nome, raca);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _addMarker(LatLng position, String nome, String raca) {
    final marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(title: nome, snippet: raca),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: GoogleMap(
        initialCameraPosition: _initialPosition,
        onMapCreated: (controller) => _mapController = controller,
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (position) {
          _showAddMarkerDialog(position);
        },
      ),
    );
  }
}
