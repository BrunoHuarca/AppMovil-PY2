import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String userId = "";
  String nombre = "Cargando...";
  String celular = "Cargando...";
  String direccion = "Cargando...";
  String referencia = "Cargando...";
  String ubicacion = '{"lat":-16.426203,"lng":-71.50644}';
  LatLng? _selectedLocation;
  late final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  try {
    String? token = await _secureStorage.read(key: 'token');

    if (token == null || token.isEmpty) {
      _logout();
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    if (decodedToken.containsKey('exp')) {
      int? expiration = decodedToken['exp'] as int?;
      if (expiration != null &&
          DateTime.fromMillisecondsSinceEpoch(expiration * 1000)
              .isBefore(DateTime.now())) {
        _logout();
        return;
      }
    }

    if (!decodedToken.containsKey('Usuario_ID')) {
      _logout();
      return;
    }

    userId = decodedToken['Usuario_ID'].toString();

    final response = await http.get(
      Uri.parse('https://mixturarosaaqp.com/api/usuarios/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> user = json.decode(response.body);

      setState(() {
        nombre = user['Nombre'] ?? "Sin nombre";
        celular = user['Numero'] ?? "Sin número";
        direccion = user['Direccion'] ?? "Sin dirección";
        referencia = user['Referencia'] ?? "Sin referencia";

        // Verificar si la ubicación existe en la API
        if (user.containsKey('Ubicacion') && user['Ubicacion'] != null) {
          try {
            Map<String, dynamic> ubicacionData = jsonDecode(user['Ubicacion']);
            ubicacion = jsonEncode(ubicacionData); // Guarda como string JSON

            // Actualiza la ubicación seleccionada
            _selectedLocation = LatLng(
              ubicacionData['lat'],
              ubicacionData['lng'],
            );
          } catch (e) {
            print("⚠️ Error al convertir la ubicación: $e");
          }
        }
      });

      print("📥 Ubicación cargada correctamente: $ubicacion");
    } else {
      _showError('Error al obtener los datos del usuario');
    }
  } catch (e) {
    _showError('Error de conexión: $e');
  }
}



Future<void> _updateUserData(String campo, dynamic nuevoValor) async {
  try {
    if (nuevoValor == null || (nuevoValor is String && nuevoValor.isEmpty)) {
      _showError("El valor no puede estar vacío.");
      return;
    }

    String? token = await _secureStorage.read(key: 'token');

    if (token == null) {
      _logout();
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    var userId = decodedToken['Usuario_ID']?.toString();

    if (userId == null) {
      _logout();
      return;
    }
    Map<String, dynamic> body = {
      "id": userId,
      campo.toLowerCase(): campo == "Ubicacion" ? nuevoValor : nuevoValor,

    };

    print("📤 Enviando datos al servidor: ${jsonEncode(body)}");


    final response = await http.put(
      Uri.parse('https://mixturarosaaqp.com/api/usuarios/editar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    print("📥 Respuesta del servidor: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      _showSuccess("Datos actualizados correctamente.");
      await Future.delayed(Duration(milliseconds: 500));
      _loadUserData(); // 🔄 Recargar datos del usuario después de actualizar
    } else {
      _showError("Error al actualizar datos: ${response.body}");
    }
  } catch (e) {
    _showError("Error de conexión: $e");
  }
}


void _showSuccess(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  ));
}


void _showEditModal(String field, String title, String currentValue) {
  bool isPasswordField = field.toLowerCase() == "contraseña"; 

  TextEditingController controller = TextEditingController(
    text: isPasswordField ? "" : currentValue, // 🔥 Si es contraseña, inicia vacío
  );
  TextEditingController confirmController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        title: Text(
          "Editar $title",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo para ingresar el nuevo valor (o contraseña)
            TextField(
              controller: controller,
              obscureText: isPasswordField, // Oculta el texto si es contraseña
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: isPasswordField ? "Ingrese nueva contraseña" : "Ingrese nuevo $title",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            if (isPasswordField) ...[ // Si es contraseña, pide confirmación
              SizedBox(height: 10),
              TextField(
                controller: confirmController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Confirme nueva contraseña",
                  hintStyle: TextStyle(color: Colors.white54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () {
              if (isPasswordField) {
                if (controller.text != confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Las contraseñas no coinciden", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                  );
                  return;
                }
              }

              _updateUserData(field, controller.text);
              Navigator.pop(context); // Cierra el modal
            },
            child: Text("Guardar", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      );
    },
  );
}


void _openEditModal(String nombreActual, String numeroActual) {
  TextEditingController _nombreController = TextEditingController(text: nombreActual);
  TextEditingController _numeroController = TextEditingController(text: numeroActual);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Editar Información"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: "Nuevo Nombre"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _numeroController,
              decoration: InputDecoration(labelText: "Nuevo Número"),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cierra el modal sin guardar
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateUserData("Nombre", _nombreController.text.trim());
              await _updateUserData("Numero", _numeroController.text.trim());
              Navigator.pop(context); // Cierra el modal después de actualizar
            },
            child: Text("Guardar"),
          ),
        ],
      );
    },
  );
}
void _showLocationPicker(BuildContext context) {
  LatLng initialPosition = LatLng(-16.418895, -71.530218); // Predeterminado en Arequipa
  List<dynamic> searchResults = [];
  bool showSuggestions = false;
  String ubicacionNombre = "Ubicación actual"; // Nombre de la ubicación a mostrar en el TextField

  try {
    if (ubicacion.isNotEmpty) {
      Map<String, dynamic> ubicacionData = jsonDecode(ubicacion);
      initialPosition = LatLng(ubicacionData['lat'], ubicacionData['lng']);
      _selectedLocation = initialPosition;
      ubicacionNombre = ubicacionData['nombre'] ?? "Ubicación guardada"; // Si hay un nombre, lo usamos
    }
  } catch (e) {
    print("⚠️ Error al decodificar ubicación: $e");
  }

  TextEditingController _searchController = TextEditingController(text: ubicacionNombre);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Selecciona tu Ubicación"),
            content: Container(
              width: double.maxFinite,
              height: 450,
              child: Column(
                children: [
                  // Campo de búsqueda con ubicación guardada
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Buscar ubicación",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          String query = _searchController.text.trim();
                          if (query.isNotEmpty) {
                            try {
                              final response = await http.get(Uri.parse(
                                  "https://nominatim.openstreetmap.org/search?q=$query&format=json"));
                              final List data = jsonDecode(response.body);
                              setState(() {
                                searchResults = data;
                                showSuggestions = true;
                              });
                            } catch (e) {
                              print("⚠️ Error en búsqueda: $e");
                            }
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Sugerencias de búsqueda
                  if (showSuggestions && searchResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ListTile(
                            title: Text(result["display_name"]),
                            onTap: () {
                              LatLng newLocation = LatLng(
                                double.parse(result["lat"]),
                                double.parse(result["lon"]),
                              );
                              setState(() {
                                // ✅ Mueve el mapa sin cambiar el marcador
                                _mapController.move(newLocation, 15.0);
                                _searchController.text = result["display_name"];
                                searchResults.clear();
                                showSuggestions = false;
                              });
                            },
                          );
                        },
                      ),
                    ),

                  // Mapa con ubicación inicial y marcador
                  SizedBox(
                    height: 300,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        center: _selectedLocation ?? initialPosition,
                        zoom: 15.0,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedLocation = point;
                          });
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _selectedLocation ?? initialPosition, // ✅ Muestra la ubicación guardada
                              builder: (ctx) => Icon(Icons.location_pin, color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar", style: TextStyle(color: Colors.redAccent)),
              ),
              TextButton(
                onPressed: () {
                  if (_selectedLocation != null) {
                    Map<String, dynamic> newLocation = {
                      "lat": _selectedLocation!.latitude,
                      "lng": _selectedLocation!.longitude,
                      "nombre": _searchController.text, // ✅ Guardamos el nombre de la ubicación
                    };
                    _updateUserData("Ubicacion", newLocation);
                  }
                  Navigator.pop(context);
                },
                child: Text("Guardar", style: TextStyle(color: Colors.blueAccent)),
              ),
            ],
          );
        },
      );
    },
  );
}



  Future<void> _logout() async {
    await _secureStorage.deleteAll(); // Borra todos los datos almacenados
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige a LoginScreen
    );
  }


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
  Widget _buildLogoutButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _logout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.redAccent
                ),
              ),
              Icon(Icons.logout, color: Colors.redAccent),
            ],
          ),
        ),
        Divider(color: Colors.white54, thickness: 0.5),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF280E0E),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      celular,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _openEditModal(nombre, celular),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("Editar", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),

              ],
            ),

            SizedBox(height: 10),
            Divider(color: Colors.white),

            SizedBox(height: 10),
            Text(
              "Perfil",
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            _buildProfileField("Dirección", direccion, "Direccion"),
            _buildProfileField("Referencia", referencia, "Referencia"),
            _buildProfileField(
              "Ubicación",
              () {
                try {
                  if (ubicacion.isNotEmpty) {
                    Map<String, dynamic> ubicacionData = json.decode(ubicacion);
                    return "Lat: ${ubicacionData['lat']}, Long: ${ubicacionData['lng']}";
                  }
                } catch (e) {
                  print("⚠️ Error al decodificar ubicación: $e");
                }
                return "Sin ubicación";
              }(),
              "Ubicacion",
              isLocation: true,
            ),
            _buildProfileField("Contraseña", "********", "Contraseña"),

            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }
  // Modifica _buildProfileField para manejar ubicación
  Widget _buildProfileField(String title, String value, String field, {bool isLocation = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => isLocation ? _showLocationPicker(context) : _showEditModal(field, title, value),
              child: Text("Actualizar", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.white)),
        Divider(color: Colors.white54, thickness: 0.5),
        SizedBox(height: 8),
      ],
    );
  }
}
