import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  LatLng _currentPosition = LatLng(-16.4090, -71.5375); // Coordenadas de ejemplo
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation(); // Obtener la ubicación al iniciar
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de GPS está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si el servicio no está habilitado, muestra un mensaje
      return;
    }

    // Pedir permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si los permisos son denegados, mostrar un mensaje
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Manejar el caso donde los permisos están bloqueados permanentemente
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition, 18.0); // Mover el mapa a la ubicación actual
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tu Pedido',
          style: TextStyle(color: Colors.black), // Letras del AppBar en negro
        ),
        backgroundColor: Color(0xFFC44949), // Fondo del AppBar color #C44949
      ),
      body: Column(
        children: [
          // Mapa cuadrado en la parte superior
          Container(
            height: 200.0, // Ajusta la altura del mapa según tus necesidades
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentPosition, // Usar la ubicación actual
                zoom: 18.0, // Zoom inicial
                minZoom: 16.0,
                maxZoom: 18.0,
                interactiveFlags: InteractiveFlag.drag, // Solo permite arrastrar
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentPosition, // Actualiza el marcador con la ubicación actual
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Detalles del pedido
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detalles del Pedido',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto en blanco
                  ),
                ),
                SizedBox(height: 16.0), // Espacio entre elementos
                _buildOrderDetailRow('Ubicación', 'Calle Ejemplo 123'),
                _buildOrderDetailRow('Referencia', 'Cerca del parque principal'),
                _buildOrderDetailRow('Número del que pidió', '+51 987 654 321'),
                _buildOrderDetailRow('Número del delivery', '+51 987 654 322'),
                _buildOrderDetailRow('Tiempo de llegada', '15 min'),
                _buildOrderDetailRow('Precio', 'S/ 45.00'),
                _buildOrderDetailRow('Nombre del que pidió', 'Juan Pérez'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Función para construir las filas de detalles
  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Espacio vertical
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Texto de las etiquetas en blanco
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white70, // Texto de los valores en blanco suave
            ),
          ),
        ],
      ),
    );
  }
}
