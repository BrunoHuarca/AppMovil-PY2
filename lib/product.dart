import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String name;
  final String price;
  final String time;

  ProductScreen({required this.name, required this.price, required this.time});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _cantidadPlatos = 1;
  double _precioTotal = 0.0;
  double _precioBase = 0.0;
  bool _incaCola = false;
  bool _cocaCola = false;
  bool _pepsi = false;

  @override
  void initState() {
    super.initState();
    _precioBase = double.parse(widget.price.replaceAll('S/', '').trim());
    _calcularPrecioTotal();
  }

  void _calcularPrecioTotal() {
    double adicionales = 0.0;
    if (_incaCola) adicionales += 3.0;
    if (_cocaCola) adicionales += 3.0;
    if (_pepsi) adicionales += 3.0;

    setState(() {
      _precioTotal = (_precioBase + adicionales) * _cantidadPlatos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Contenido superior con scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Imagen del plato
                  Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/plate.jpg'), // Reemplazar con la imagen del plato
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Nombre del plato y descripción
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Descripción breve del plato...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 16.0),

                  // Precio
                  Text(
                    'Precio: S/${widget.price}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),

                  // Línea de separación
                  Divider(color: Colors.grey),

                  // Texto 'Adicionales'
                  Text(
                    'Adicionales',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),

                  // Opciones adicionales con checkboxes circulares
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Inca Cola + S/3.00'),
                      Checkbox(
                        value: _incaCola,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            _incaCola = value!;
                            _calcularPrecioTotal();
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Coca Cola + S/3.00'),
                      Checkbox(
                        value: _cocaCola,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            _cocaCola = value!;
                            _calcularPrecioTotal();
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Pepsi + S/3.00'),
                      Checkbox(
                        value: _pepsi,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            _pepsi = value!;
                            _calcularPrecioTotal();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Contenido inferior fijo
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, -2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Selector de cantidad de platos y precio total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Selector de cantidad
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (_cantidadPlatos > 1) {
                              setState(() {
                                _cantidadPlatos--;
                                _calcularPrecioTotal();
                              });
                            }
                          },
                        ),
                        Text(
                          '$_cantidadPlatos platos',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _cantidadPlatos++;
                              _calcularPrecioTotal();
                            });
                          },
                        ),
                      ],
                    ),

                    // Precio total
                    Text(
                      'Total: S/$_precioTotal',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),

                // Botón 'Agregar'
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acción para agregar el producto al carrito
                    },
                    child: Text('Agregar'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
