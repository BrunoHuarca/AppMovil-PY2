import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu.dart';
import 'menuadmin.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await _secureStorage.read(key: 'token');

    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String rol = decodedToken['Rol'];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    rol == 'admin' ? MenuAdminScreen() : MenuScreen()),
          );
        }
      });
    }
  }

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
      print('🔸 Respuesta del servidor: $responseData');

      if (response.statusCode == 200) {
        String? token = responseData['token'];

        if (token != null) {
          await _secureStorage.write(key: 'token', value: token);

          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String rol = decodedToken['Rol'];

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      rol == 'admin' ? MenuAdminScreen() : MenuScreen()),
            );
          }
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
                'assets/images/Logo-2.png',
                height: 150,
              ),
              SizedBox(height: 32.0),
              TextField(
                controller: _numeroController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Ingresa tu nombre',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                    borderSide: BorderSide(color: Color(0xFFEA572A)), // Borde en #EA572A
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                    borderSide: BorderSide(color: Color(0xFFEA572A), width: 2.0), // Borde más grueso al enfocar
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.white),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: TextStyle(color: Colors.white),
              ),

              SizedBox(height: 16.0),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Ingresa tu contraseña',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                    borderSide: BorderSide(color: Color(0xFFEA572A)), // Borde en #EA572A
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                    borderSide: BorderSide(color: Color(0xFFEA572A), width: 2.0), // Borde más grueso al enfocar
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                style: TextStyle(color: Colors.white),
              ),


              SizedBox(height: 32.0),
              _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEA572A), // Fondo naranja
                      foregroundColor: Colors.white, // Texto blanco
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                      ),
                    ),
                    child: Text('Iniciar sesión'),
                  ),

              SizedBox(height: 16.0),
              Text(
                '¿Aún no tienes cuenta?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
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
                  foregroundColor: Color(0xFFEA572A),
                  textStyle: TextStyle(
                      fontSize: 16, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
