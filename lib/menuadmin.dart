import 'package:flutter/material.dart';

class MenuAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Administrador'),
      ),
      body: Center(
        child: Text(
          'Bienvenido al Menú de Administrador',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
