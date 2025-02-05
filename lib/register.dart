import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart'; // Para volver a la pantalla principal después de registrarse.

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
          'Ubicacion': _ubicacionController.text.trim(), // Nuevo campo
          'Rol': 'usuario', // Se asigna por defecto
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Mixtura ROSA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.0),

                  TextField(
                    controller: _numeroController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Número',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: _direccionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: _referenciaController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Referencia',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: _ubicacionController,
                    decoration: InputDecoration(
                      labelText: 'Ubicación',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.map),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'He leído y acepto los términos y condiciones de uso',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),

                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _register,
                          child: Text('Registrarse'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                  SizedBox(height: 16.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('¿Ya tienes una cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                              color: Colors.blue, decoration: TextDecoration.underline),
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
