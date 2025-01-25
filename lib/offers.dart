import 'package:flutter/material.dart';

class OffersScreen extends StatefulWidget {
  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  // Lista de imágenes de ofertas (en este caso, no se carga ninguna imagen por ahora)
  List<String> offers = ['assets/offer1.jpg', 'assets/offer2.jpg', 'assets/offer3.jpg'];

  // Método para eliminar una oferta (aún no funcional)
  void _removeOffer(int index) {
    setState(() {
      offers.removeAt(index);
    });
  }

  // Método para abrir el formulario de agregar una oferta (sin funcionalidad)
  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nueva Oferta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Selecciona una imagen para agregar como oferta.'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Este botón no realiza ninguna acción por ahora
                  Navigator.pop(context); // Solo cierra el cuadro de diálogo
                },
                child: Text('Subir Imagen (No funcional)'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Ofertas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Título "Las mejores ofertas"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Las mejores ofertas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Lista de imágenes vertical
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Desactiva el desplazamiento en esta lista
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Card(
                        child: Image.asset(offers[index]),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            _removeOffer(index);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Botón "Agregar" debajo de la lista
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showImagePickerDialog, // Mostrar el formulario
                child: Text('Agregar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: Size(double.infinity, 50), // Hacer el botón más grande
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
