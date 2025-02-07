import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu.dart'; // Importa la vista de menú.
import 'menuadmin.dart'; // Importa la vista de menú admin.
import 'register.dart'; // Importa la vista de registro.
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF280e0e), // Color de fondo #280e0e
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String apiUrl = 'https://mixturarosaaqp.com/api/auth/login';
    final String nombre = _numeroController.text.trim();
    final String password = _passwordController.text.trim();

    if (nombre.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese nombre y contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Nombre': nombre, 'Contraseña': password}),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Respuesta del servidor: $responseData');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inicio de sesión exitoso')),
        );

        // Extraer token y decodificarlo
        String? token = responseData['token'];
        if (token != null) {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String rol = decodedToken['Rol']; // Extrae el rol del usuario

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (rol == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuAdminScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            }
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseData['mensaje'] ?? 'Error al iniciar sesión')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/Logo-2.png', // Reemplaza esto con la ruta de tu logo.
                height:
                    150, // Puedes ajustar el tamaño de la imagen según lo necesites.
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: _numeroController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(
                      color: Colors
                          .white), // Cambia el color de la etiqueta a blanco
                  hintText: 'Ingresa tu nombre', // Placeholder
                  hintStyle: TextStyle(
                      color: Colors
                          .white), // Cambia el color del placeholder a blanco
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Borde blanco cuando el campo no está seleccionado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Borde blanco cuando el campo está seleccionado
                  ),
                  prefixIcon: Icon(Icons.person,
                      color:
                          Colors.white), // Cambia el color del ícono a blanco
                  filled: true,
                  fillColor: Colors.transparent, // Fondo transparente
                ),
                style: TextStyle(
                    color: Colors
                        .white), // Cambia el color del texto ingresado a blanco
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(
                      color: Colors
                          .white), // Cambia el color de la etiqueta a blanco
                  hintText: 'Ingresa tu contraseña', // Placeholder
                  hintStyle: TextStyle(
                      color: Colors
                          .white), // Cambia el color del placeholder a blanco
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Borde blanco cuando el campo no está seleccionado
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Borde blanco cuando el campo está seleccionado
                  ),
                  prefixIcon: Icon(Icons.lock,
                      color:
                          Colors.white), // Cambia el color del ícono a blanco
                  filled: true,
                  fillColor: Colors.transparent, // Fondo transparente
                ),
                obscureText: true,
                style: TextStyle(
                    color: Colors
                        .white), // Cambia el color del texto ingresado a blanco
              ),
              SizedBox(height: 32.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Iniciar sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(
                            0xFFEA572A), // Cambia el color de fondo del botón a #EA572A
                        foregroundColor:
                            Colors.white, // Cambia el color del texto a blanco
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
              SizedBox(height: 16.0),
              Text(
                '¿Aún no tienes cuenta?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto en blanco
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Registrarse'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Color(0xFFEA572A), // Cambia el color del texto a #EA572A
                  textStyle: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
