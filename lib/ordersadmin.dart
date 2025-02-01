import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart'; // Para manejar LatLng

class OrdersAdminScreen extends StatefulWidget {
  @override
  _OrdersAdminScreenState createState() => _OrdersAdminScreenState();
}

class _OrdersAdminScreenState extends State<OrdersAdminScreen> {
  int _selectedIndex = 1;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  // Cargar pedidos desde la API
  Future<void> _loadPedidos() async {
    try {
      final response = await http.get(Uri.parse('https://mixturarosaaqp.com/api/pedidos/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        List<Marker> markers = data.map((pedido) {
          final ubicacion = jsonDecode(pedido['Ubicacion_Entrega']);
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(ubicacion['lat'], ubicacion['lng']),
            builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40.0),
          );
        }).toList();

        setState(() {
          _markers = markers;
        });
      } else {
        print("Error al cargar los pedidos: ${response.statusCode}");
      }
    } catch (e) {
      print("Error cargando los pedidos: $e");
    }
  }

  // Maneja los cambios en el menú de navegación inferior
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Lógica para el botón de Inicio
    } else if (index == 1) {
      // Lógica para el botón de Pedidos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Pedidos'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-16.426203, -71.50644), // Posición inicial del mapa
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",  // URL para OpenStreetMap
                subdomains: ['a', 'b', 'c'],  // Subdominios para los tiles
              ),
              MarkerLayer(
                markers: _markers, // Mostrar los marcadores en el mapa
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              "© OpenStreetMap contributors",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pedidos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
