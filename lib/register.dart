import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Para volver a la pantalla principal después de registrarse.
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'login.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController(); // Nuevo campo
  String _ubicacionJson = ""; // Almacena {"lat": ..., "lng": ...}

  bool _isChecked = false; // Checkbox de términos y condiciones.
  bool _isLoading = false; // Estado para mostrar el indicador de carga.

  Future<void> _register() async {
    if (_numeroController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        _referenciaController.text.isEmpty ||
        _ubicacionController.text.isEmpty || // Validar Ubicacion
        !_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos y acepte los términos y condiciones'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String apiUrl = 'https://mixturarosaaqp.com/api/auth/register'; // URL de la API de registro
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Numero': _numeroController.text.trim(),
          'Nombre': _nombreController.text.trim(),
          'Contraseña': _passwordController.text.trim(),
          'Direccion': _direccionController.text.trim(), // Corregido (sin tilde)
          'Referencia': _referenciaController.text.trim(),
          'Ubicacion': _ubicacionJson, // Nuevo campo
          'Rol': 'usuario', // Se asigna spor defecto
        }),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Respuesta del servidor: $responseData');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso, por favor inicie sesión')),
        );

        // Navegar al LoginScreen después del registro exitoso
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['mensaje'] ?? 'Error al registrarse'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
Color borderColor = Color(0xFFEA572A);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 16.0, bottom: 16.0, left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Regístrate',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Ingrese la información para crear su cuenta con nosotros',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.0),
                  TextField(
                    controller: _numeroController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Número',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.phone, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _nombreController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _direccionController,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.home, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _referenciaController,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Referencia',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.location_on, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _ubicacionController,
                    readOnly: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Ubicación',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: borderColor, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.map, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_searching, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                onLocationSelected: (locationJson, address) {
                                  setState(() {
                                    _ubicacionController.text = address;
                                    _ubicacionJson = locationJson;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        activeColor: borderColor, // Color del checkbox naranja
                        checkColor: Colors.white, // Check blanco
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'He leído y acepto los términos y condiciones de uso',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEA572A), // Fondo naranja
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                          ),
                        ),
                        child: Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.white, // Texto blanco
                            fontWeight: FontWeight.normal, // Negrita opcional
                          ),
                        ),
                      ),

                  SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '¿Ya tienes una cuenta?', 
                        style: TextStyle(color: Colors.white), // Texto blanco
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                            color: Color(0xFFEA572A), // Azul
                            fontWeight: FontWeight.bold, // Negrita
                            decoration: TextDecoration.underline, // Subrayado
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class MapScreen extends StatefulWidget {
  final Function(String, String) onLocationSelected;

  MapScreen({required this.onLocationSelected});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  TextEditingController _searchController = TextEditingController();
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      selectedLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(selectedLocation!, 15.0);
    });
  }

  void _onTap(LatLng latlng) async {
    setState(() {
      selectedLocation = latlng;
    });
    await _reverseGeocode(latlng);
  }

  Future<void> _reverseGeocode(LatLng latlng) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.latitude}&lon=${latlng.longitude}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String address = data['display_name'] ?? "Ubicación desconocida";
      setState(() {
        _searchController.text = address;
      });
    }
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text;
    if (query.isEmpty) return;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?format=json&q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        double lat = double.parse(data[0]['lat']);
        double lon = double.parse(data[0]['lon']);
        setState(() {
          selectedLocation = LatLng(lat, lon);
          _mapController.move(selectedLocation!, 15.0);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Seleccionar Ubicación",
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
        backgroundColor: Color(0xFF280E0E), // Fondo en #280E0E
        elevation: 0, // Opcional: Elimina la sombra del AppBar
        iconTheme: IconThemeData(color: Colors.white), // Íconos (como el botón de retroceso) en blanco
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Buscar calle o distrito",
                    hintStyle: TextStyle(color: Colors.white), // Hint en blanco
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                      borderSide: BorderSide(color: Color(0xFFEA572A)), // Borde en #EA572A
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                      borderSide: BorderSide(color: Color(0xFFEA572A), width: 2.0), // Borde más grueso al enfocar
                    ),
                    filled: true,
                    fillColor: Colors.transparent, // Fondo transparente
                  ),
                  style: TextStyle(color: Colors.white), // Texto en blanco
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Color(0xFFEA572A)), // Ícono en naranja
                onPressed: _searchLocation,
              )
            ],

            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(-16.426203, -71.50644),
                    zoom: 13.0,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                    onTap: (tapPosition, latlng) => _onTap(latlng),
                    interactiveFlags: InteractiveFlag.all, // 🔥 Habilita zoom con pellizco
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: selectedLocation!,
                            builder: (context) =>
                                Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.zoom_in),
                        onPressed: () {
                          _mapController.move(_mapController.center, _mapController.zoom + 1);
                        },
                      ),
                      SizedBox(height: 8),
                      FloatingActionButton(
                        mini: true,
                        child: Icon(Icons.zoom_out),
                        onPressed: () {
                          _mapController.move(_mapController.center, _mapController.zoom - 1);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (selectedLocation != null) {
            widget.onLocationSelected(
              '{"lat":${selectedLocation!.latitude},"lng":${selectedLocation!.longitude}}',
              _searchController.text,
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
