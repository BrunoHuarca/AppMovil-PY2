import 'package:flutter/material.dart';
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

  bool _isChecked = false; // Estado del checkbox para los términos y condiciones.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          // Navegar de vuelta al LoginScreen si se presiona la flecha de retroceso.
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
                  // Título principal 'Mixtura ROSA'
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

                  // Campo para ingresar el número de celular
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

                  // Campo para ingresar el nombre
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Campo para ingresar la contraseña
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

                  // Campo para ingresar la dirección (más largo)
                  TextField(
                    controller: _direccionController,
                    maxLines: 2, // Hacer el campo más largo
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Campo para ingresar la referencia (más largo)
                  TextField(
                    controller: _referenciaController,
                    maxLines: 2, // Hacer el campo más largo
                    decoration: InputDecoration(
                      labelText: 'Referencia',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Checkbox para aceptar términos y condiciones
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

                  // Botón 'Registrarse'
                  ElevatedButton(
                    onPressed: () {
                      // Verificar que todos los campos estén llenos y que se haya marcado el checkbox.
                      if (_numeroController.text.isNotEmpty &&
                          _nombreController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty &&
                          _direccionController.text.isNotEmpty &&
                          _referenciaController.text.isNotEmpty &&
                          _isChecked) {
                        // Navegar de vuelta al LoginScreen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                        print('Registro exitoso');
                      } else {
                        // Mostrar un mensaje si faltan campos por llenar o si no se ha aceptado los términos.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, complete todos los campos y acepte los términos y condiciones'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Registrarse'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Enlace para ir al LoginScreen si ya se tiene cuenta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('¿Ya tienes una cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Ingresar',
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
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
