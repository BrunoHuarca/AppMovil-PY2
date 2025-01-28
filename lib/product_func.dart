class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final bool available;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.available,
    required this.createdAt,
  });

  // Método para convertir el JSON a un objeto Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['Producto_ID'],
      name: json['Nombre'],
      description: json['Descripcion'],
      price: double.parse(json['Precio']), // Parseamos el precio a double
      imageUrl: json['Imagen_Url'],
      categoryId: json['Categoria_ID'].toString(),
      available: json['Disponible'] == 1, // Convertimos a booleano
      createdAt: json['Fecha_Creacion'],
    );
  }
}