import 'package:flutter/material.dart';
import 'menu.dart'; // Importa la vista de menú.
import 'menuadmin.dart'; // Importa la vista de menú admin.
import 'register.dart'; // Importa la vista de registro.

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
        scaffoldBackgroundColor: Colors.white, // Cambiar fondo a blanco
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false, // Eliminar banner de debug
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              // Título del formulario
              Text(
                'Iniciar sesión',
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
                keyboardType: TextInputType.phone, // Para mostrar teclado numérico
                decoration: InputDecoration(
                  labelText: 'Número',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
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
                obscureText: true, // Ocultar la contraseña
              ),
              SizedBox(height: 32.0),

              // Botón para iniciar sesión
              ElevatedButton(
                onPressed: () {
                  // Validar las credenciales.
                  final numero = _numeroController.text;
                  final password = _passwordController.text;

                  if (numero == '999999999' && password == '123') {
                    // Navegar a Menu Admin si las credenciales son correctas.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuAdminScreen()),
                    );
                  } else {
                    // Navegar a Menu si las credenciales no son de admin.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuScreen()),
                    );
                  }
                },
                child: Text('Iniciar sesión'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 16.0),

              // Texto "Aún no tienes cuenta?"
              Text(
                '¿Aún no tienes cuenta?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              // Enlace de registrarse
              TextButton(
                onPressed: () {
                  // Navegar a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Registrarse'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // Cambiar el color del texto
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
