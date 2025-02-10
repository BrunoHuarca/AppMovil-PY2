import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';
import 'login.dart';

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
  String ubicacion = "Cargando...";

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

        String formattedUbicacion = "Sin ubicación";
        if (user.containsKey('Ubicacion') && user['Ubicacion'] != null) {
          try {
            Map<String, dynamic> ubicacionData = json.decode(user['Ubicacion']);
            double lat = ubicacionData['lat'] ?? 0.0;
            double lng = ubicacionData['lng'] ?? 0.0;
            formattedUbicacion = "Lat: $lat, Long: $lng";
          } catch (e) {
            print("⚠️ Error al procesar la ubicación: $e");
          }
        }

        setState(() {
          nombre = user['Nombre'] ?? "Sin nombre";
          celular = user['Numero'] ?? "Sin número";
          direccion = user['Direccion'] ?? "Sin dirección";
          referencia = user['Referencia'] ?? "Sin referencia";
          ubicacion = formattedUbicacion;
        });
      } else {
        _showError('Error al obtener los datos del usuario');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    }
  }

Future<void> _updateUserData(String campo, String nuevoValor) async {
  try {
    if (nuevoValor.isEmpty) {
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

    // 🔥 Corrección: Renombrar "contraseña" a "contrasena" para la API
    String campoAPI = campo.toLowerCase() == "contraseña" ? "contrasena" : campo.toLowerCase();

    // 🔒 Si es contraseña, la encriptamos con bcrypt
    // if (campoAPI == "contrasena") {
    //   nuevoValor = BCrypt.hashpw(nuevoValor, BCrypt.gensalt());
    // }

    // 🔥 Formato corregido del body
    Map<String, dynamic> body = {
      "id": userId,
      campoAPI: nuevoValor, // Usa el nombre correcto del campo
    };

    print("📤 Enviando datos al servidor: ${json.encode(body)}");

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
      _loadUserData(); // Recargar datos del usuario
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
        backgroundColor: Colors.black,
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
            _buildProfileField("Ubicación", ubicacion, "Ubicacion"),
            _buildProfileField("Contraseña", "********", "Contraseña"),

            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String title, String value, String field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => _showEditModal(field, title, value),
              child: Text("Actualizar",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        Divider(color: Colors.white54, thickness: 0.5),
        SizedBox(height: 8),
      ],
    );
  }
}
