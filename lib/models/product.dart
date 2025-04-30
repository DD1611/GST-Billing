class Product {
  final String id;
  final String name;
  final double price;
  final double gstRate;
  final String? description;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gstRate,
    this.description,
    this.category,
  });

  // Calculate CGST (half of GST rate)
  double get cgst => (price * gstRate) / 2;

  // Calculate SGST (half of GST rate)
  double get sgst => (price * gstRate) / 2;

  // Calculate total price including GST
  double get totalPrice => price + cgst + sgst;

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'gstRate': gstRate,
      'description': description,
      'category': category,
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      gstRate: map['gstRate'],
      description: map['description'],
      category: map['category'],
    );
  }
}
