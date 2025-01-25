import 'package:flutter/material.dart';

class DishesScreen extends StatefulWidget {
  @override
  _DishesScreenState createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  // Lista de platos
  List<String> dishes = ['Plato 1', 'Plato 2', 'Plato 3'];

  // Método para eliminar un plato
  void _removeDish(int index) {
    setState(() {
      dishes.removeAt(index);
    });
  }

  // Método para abrir el formulario de agregar plato
  void _showAddDishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Nuevo Plato'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AddDishForm(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Platos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Título "Administrar Platos"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Administrar Platos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Lista de platos
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Desactiva el desplazamiento en esta lista
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(dishes[index]),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: GestureDetector(
                          onTap: () {
                            _removeDish(index); // Eliminar plato
                          },
                          child: Text(
                            'X',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red, // Personaliza el estilo de la "X"
                            ),
                          ),
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
                onPressed: _showAddDishDialog, // Mostrar el formulario
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

// Formulario para agregar un nuevo plato
class AddDishForm extends StatefulWidget {
  @override
  _AddDishFormState createState() => _AddDishFormState();
}

class _AddDishFormState extends State<AddDishForm> {
  bool _isPlatoFuerte = false;
  bool _isAdicional = false;
  bool _isDisponible = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Campo Nombre
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          // Campo Descripción
          TextFormField(
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          // Campo Precio
          TextFormField(
            decoration: InputDecoration(labelText: 'Precio'),
            keyboardType: TextInputType.number,
          ),
          // Campo Img_URL
          TextFormField(
            decoration: InputDecoration(labelText: 'Img_URL'),
          ),
          SizedBox(height: 16.0),
          // Categoría
          Text('Categoría:'),
          CheckboxListTile(
            title: Text('Plato Fuerte'),
            value: _isPlatoFuerte,
            onChanged: (value) {
              setState(() {
                _isPlatoFuerte = value!;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Adicional'),
            value: _isAdicional,
            onChanged: (value) {
              setState(() {
                _isAdicional = value!;
              });
            },
          ),
          // Disponible
          SwitchListTile(
            title: Text('Disponible'),
            value: _isDisponible,
            onChanged: (value) {
              setState(() {
                _isDisponible = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          // Botón para cerrar el formulario
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar el formulario
            },
            child: Text('Guardar Plato'),
          ),
        ],
      ),
    );
  }
}
