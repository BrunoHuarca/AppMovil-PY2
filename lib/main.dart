import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'menuadmin.dart'; // Importa el menú de admin
import 'menu.dart'; // Importa el menú de cliente
import 'login.dart'; // Pantalla de inicio de sesión

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Opcional: Oculta la etiqueta de debug
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF280E0E), // Aplica el color globalmente
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(); // ✅ Definir almacenamiento seguro

  @override
  void initState() {
    super.initState();
    _getInitialScreen(); // ✅ Llamar a la función para decidir la pantalla inicial
  }

  Future<void> _getInitialScreen() async {
    String? token = await _secureStorage.read(key: 'token');

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print('🔹 Token decodificado: $decodedToken');

      if (decodedToken.containsKey('exp')) {
        try {
          int expiration = decodedToken['exp'];
          DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expiration * 1000);
          
          if (expirationDate.isBefore(DateTime.now())) {
            print('⚠️ El token ha expirado');
            await _secureStorage.delete(key: 'token');
            _navigateToScreen(LoginScreen());
            return;
          }
        } catch (e) {
          print('⚠️ Error al procesar la fecha de expiración: $e');
        }
      } else {
        print('✅ El token no tiene expiración, se asume válido permanentemente.');
      }

      String rol = decodedToken['Rol'] ?? 'cliente';
      _navigateToScreen(rol == 'admin' ? MenuAdminScreen() : MenuScreen());
    } else {
      _navigateToScreen(LoginScreen());
    }
  }

  void _navigateToScreen(Widget screen) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Muestra un loader mientras decide a dónde ir
      ),
    );
  }
}
