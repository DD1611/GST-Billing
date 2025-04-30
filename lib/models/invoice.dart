import 'package:uuid/uuid.dart';
import 'product.dart';

class InvoiceItem {
  final Product product;
  final int quantity;

  InvoiceItem({
    required this.product,
    required this.quantity,
  });

  double get subtotal => product.price * quantity;
  double get cgst => product.cgst * quantity;
  double get sgst => product.sgst * quantity;
  double get total => product.totalPrice * quantity;
}

class Invoice {
  final String id;
  final DateTime date;
  final List<InvoiceItem> items;
  final String? customerName;
  final String? customerPhone;

  Invoice({
    String? id,
    DateTime? date,
    required this.items,
    this.customerName,
    this.customerPhone,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get totalCgst => items.fold(0, (sum, item) => sum + item.cgst);
  double get totalSgst => items.fold(0, (sum, item) => sum + item.sgst);
  double get total => items.fold(0, (sum, item) => sum + item.total);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items
          .map((item) => {
                'product': item.product.toMap(),
                'quantity': item.quantity,
              })
          .toList(),
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      date: DateTime.parse(map['date']),
      items: (map['items'] as List)
          .map((item) => InvoiceItem(
                product: Product.fromMap(item['product']),
                quantity: item['quantity'],
              ))
          .toList(),
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
    );
  }
}
