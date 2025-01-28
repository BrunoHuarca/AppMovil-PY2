import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_func.dart'; // Importa el modelo Product
import 'package:permission_handler/permission_handler.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Product> products = []; // Lista de productos
  List<Product> filteredProducts = []; // Lista filtrada de productos
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  
  // Valores del slider para el precio
  double minPrice = 5.0;
  double maxPrice = 30.0;
  
  // Rango de precios filtrado
  double currentMinPrice = 5.0;
  double currentMaxPrice = 30.0;

  @override
  void initState() {
    super.initState();
    // Obtener productos desde la API
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  // Función para hacer la solicitud HTTP
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://mixturarosaaqp.com/api/productos'));

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, parsea los productos
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          filteredProducts = products; // Inicializa la lista filtrada con todos los productos
          isLoading = false; // Cambiar el estado de carga
        });
      } else {
        // Si no fue exitosa, muestra un error
        setState(() {
          isLoading = false;
        });
        throw Exception('Error al cargar productos');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Si ocurrió un error, muestra un mensaje
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("No se pudieron cargar los productos. Intenta más tarde."),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Función para filtrar los productos
  void _filterProducts() {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(searchController.text.toLowerCase()) &&
              product.price >= currentMinPrice &&
              product.price <= currentMaxPrice)
          .toList();
    });
  }

  // Función para actualizar el rango de precios
  void _updatePriceFilter() {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.price >= currentMinPrice && product.price <= currentMaxPrice)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'RESTAURANT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Cuadro de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar plato...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          // Filtro de precio con Slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Rango de precio: S/ ${currentMinPrice.toStringAsFixed(2)} - S/ ${currentMaxPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                RangeSlider(
                  values: RangeValues(currentMinPrice, currentMaxPrice),
                  min: minPrice,
                  max: maxPrice,
                  divisions: 5,
                  labels: RangeLabels(
                    'S/ ${currentMinPrice.toStringAsFixed(2)}',
                    'S/ ${currentMaxPrice.toStringAsFixed(2)}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      currentMinPrice = values.start;
                      currentMaxPrice = values.end;
                    });
                    _updatePriceFilter(); // Aplicar filtro de precio
                  },
                ),
              ],
            ),
          ),
          // Título 'Todos los platos'
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Todos los platos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Si estamos cargando, muestra un indicador de carga
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: filteredProducts.map((product) {
                        return PlateItem(
                          name: product.name,
                          price: 'S/${product.price}',
                          time: 'N/A', // Puedes añadir un campo 'time' si lo tienes
                          imageUrl: product.imageUrl,
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class PlateItem extends StatelessWidget {
  final String name;
  final String price;
  final String time;
  final String imageUrl;

  PlateItem({
    required this.name,
    required this.price,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes hacer algo cuando el usuario toque un plato
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              // Mostrar la imagen del producto
              Image.network(
                imageUrl,
                height: 60.0,
                width: 60.0,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Si la imagen ya está cargada, se muestra
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 60.0); // Si la imagen no se carga, muestra un ícono de error
                },
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(price),
                  Text('Tiempo: $time'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
