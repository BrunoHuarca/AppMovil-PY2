import 'package:flutter/material.dart';
import 'dart:convert';
import 'menu.dart'; // Importa la pantalla de inicio (menú)
import 'shopping.dart'; // Importa la pantalla del carrito
import 'main.dart'; // Importa la pantalla principal desde main.dart
import 'myorder.dart'; // Importa la pantalla de pedidos
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nombre = "";
  String celular = "";
  String direccion = "";
  String referencia = "";
  String ubicacion = "";
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  final _secureStorage = FlutterSecureStorage();
  String? userData = await _secureStorage.read(key: 'userData');

  if (userData != null) {
    final Map<String, dynamic> user = json.decode(userData);
    setState(() {
      nombre = user['Nombre'] ?? "Sin nombre";
      celular = user['Celular'] ?? "Sin número";
      direccion = user['Direccion'] ?? "Sin dirección";
      referencia = user['Referencia'] ?? "Sin referencia";
      ubicacion =
          "Lat: ${user['Latitud'] ?? 'N/A'}, Long: ${user['Longitud'] ?? 'N/A'}";
    });
  }
}

Future<void> _logout() async {
  final _secureStorage = FlutterSecureStorage(); // Instancia de almacenamiento seguro
  await _secureStorage.delete(key: 'token'); // Eliminar token

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()), // Redirigir al login
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Sin altura
        child: Container(), // No tiene contenido
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nombre del usuario
            Text(
              nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Celular: $celular',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Acción para editar
                  },
                  child: Text('Editar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Divider(color: Colors.white),

            // Dirección
            Text(
              'Perfil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Dirección', style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la dirección
                  },
                  child: Text('Cambiar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Text(direccion, style: TextStyle(color: Colors.white)),
            Divider(color: Colors.white),

            // Referencia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Referencia', style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la referencia
                  },
                  child: Text('Cambiar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Text(referencia, style: TextStyle(color: Colors.white)),
            Divider(color: Colors.white),

            // Ubicación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Ubicación', style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la ubicación
                  },
                  child: Text('Cambiar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Text(ubicacion, style: TextStyle(color: Colors.white)),
            Divider(color: Colors.white),

            // Contraseña
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Contraseña', style: TextStyle(color: Colors.white)),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la contraseña
                  },
                  child: Text('Cambiar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Text('********', style: TextStyle(color: Colors.white)),
            Divider(color: Colors.white),

            // Ver pedido
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrderScreen()),
                );
              },
              child: Text(
                'Ver tu pedido',
                style: TextStyle(
                  color: Color(0xFFC44949),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Colors.white),

            // Cerrar sesión
            GestureDetector(
              onTap: _logout,
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Color(0xFFC44949),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: Color(0xFFEA572A),
        selectedItemColor: Color(0xFF280E0E),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi perfil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShoppingScreen()),
              );
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }
}
