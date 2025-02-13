import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_func.dart'; // Asegúrate de que este archivo esté bien definido
import 'shopping.dart'; // Importar la pantalla del carrito
import 'profile.dart'; // Importar la pantalla del perfil
import 'product.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Product> products = []; // Lista de productos
  List<Product> filteredProducts = []; // Lista filtrada de productos
  List<Product> bestProducts = []; // Lista de mejores productos
  bool isBestLoading = true; // Estado de carga para mejores productos

  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex =
      0; // Para controlar el índice seleccionado del BottomNavigationBar

  @override
  void initState() {
    super.initState();
    fetchProducts();
      fetchBestProducts(); // Cargar los mejores productos
    searchController.addListener(_filterProducts);
  }

  // Función para hacer la solicitud HTTP
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://mixturarosaaqp.com/api/productos/categoria/1'));

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, parsea los productos
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          filteredProducts =
              products; // Inicializa la lista filtrada con todos los productos
          isLoading = false; // Cambiar el estado de carga
        });
      } else {
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
            content:
                Text("No se pudieron cargar los productos. Intenta más tarde."),
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
  Future<void> fetchBestProducts() async {
    try {
      final response = await http.get(Uri.parse('https://mixturarosaaqp.com/api/productos/categoria/3'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          bestProducts = data.map((item) => Product.fromJson(item)).toList();
          isBestLoading = false;
        });
      } else {
        setState(() {
          isBestLoading = false;
        });
        throw Exception('Error al cargar los mejores productos');
      }
    } catch (error) {
      setState(() {
        isBestLoading = false;
      });
    }
  }

  // Función para filtrar los productos
  void _filterProducts() {
    setState(() {
      filteredProducts = products
          .where((product) => product.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  // Función para cambiar entre las pantallas de la barra de navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Acción para la opción 'Inicio'
        break;
      case 1:
        // Acción para la opción 'Carrito'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingScreen()),
        );
        break;
      case 2:
        // Acción para la opción 'Perfil'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:50.0, left: 16.0, bottom: 16.0, right: 16.0),
              child: Text(
                'MIXTURA ROSA',
                style: TextStyle(
                  fontSize: 18, // Tamaño de texto más pequeño
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color blanco
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
                  labelStyle: TextStyle(
                    color: Colors.grey[700], // Color gris oscuro para el placeholder
                  ),
                  filled: true, // Fondo activado
                  fillColor: Colors.white, // Fondo blanco
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                    borderSide: BorderSide.none, // Sin borde exterior
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Padding interno
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 10.0), // Más espacio a la derecha
                    child: Icon(
                      Icons.search,
                      color: Color(0xFFEA572A), // Ícono en color naranja
                    ),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black, // Texto ingresado en negro
                ),
              ),
            ),

            // Botón 'Licorería'
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity, // Ocupa todo el ancho disponible
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEA572A), // Color de fondo #EA572A
                    foregroundColor: Colors.white, // Color del texto blanco
                    padding: EdgeInsets.symmetric(vertical: 16.0), // Ajuste del padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados de 10
                    ),
                  ),
                  child: Text(
                    'Licorería',
                    style: TextStyle(fontSize: 20), // Tamaño del texto
                  ),
                ),
              ),
            ),

            // Texto 'Las Mejores Ofertas'
// Sección "Las Mejores Ofertas"
Padding(
  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Las Mejores Ofertas',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

// Carrusel de productos en oferta
// Carrusel de productos en oferta
isBestLoading
    ? Center(child: CircularProgressIndicator())
    : bestProducts.isEmpty
        ? Center(
            child: Text(
              "No hay productos en oferta",
              style: TextStyle(color: Colors.white),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.width * 0.5 + 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bestProducts.length,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                Product product = bestProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: EdgeInsets.only(right: 16.0),
                    child: Card(
                      color: Colors.transparent, // Hacer la tarjeta transparente
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12.0)),
                            child: Image.network(
                              product.imageUrl ?? '',
                              height: MediaQuery.of(context).size.width * 0.4, // Reduje el tamaño
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? 'Producto sin nombre',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white, // Color blanco
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 14, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          '30-45 MIN',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'S/. ${product.price ?? '0.00'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white, // Texto en blanco
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),



            // Título 'Todos los platos'
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0), // Agregar padding horizontal
              child: Align(
                alignment:
                    Alignment.centerLeft, // Alinear el texto a la izquierda
                child: Text(
                  'Todos los platos',
                  style: TextStyle(
                    fontSize: 18, // Reducir el tamaño del texto
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Color blanco
                  ),
                ),
              ),
            ),
            // Si estamos cargando, muestra un indicador de carga
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: (filteredProducts.isNotEmpty)
                        ? filteredProducts.map((product) {
                            return PlateItem(product: product);
                          }).toList()
                        : products.map((product) {
                            return PlateItem(product: product);
                          }).toList(),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor:
            Color(0xFFEA572A), // Color de fondo del BottomNavigationBar
        selectedItemColor: Color(0xFF280E0E), // Color para el ítem seleccionado
        unselectedItemColor: Colors.white, // Color para ítems no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlateItem extends StatelessWidget {
  final Product product;

  PlateItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            // Información del producto (Nombre, Descripción y Precio) - A la izquierda
            Expanded(
              flex: 60, // 60% del ancho para el texto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name ?? 'Nombre no disponible',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Texto en blanco
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    product.description ?? 'Sin descripción',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70, // Texto en blanco con opacidad
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'S/. ${product.price ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Precio en blanco
                    ),
                  ),
                ],
              ),
            ),

            // Imagen del producto - A la derecha
            SizedBox(width: 8), // Espaciado entre el texto y la imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
              child: Image.network(
                product.imageUrl ?? '',
                width: MediaQuery.of(context).size.width * 0.40, // 40% del ancho
                height: MediaQuery.of(context).size.width * 0.3, // Ajuste proporcional
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 60.0, color: Colors.red);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
