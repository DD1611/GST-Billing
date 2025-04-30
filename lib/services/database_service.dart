import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'gst_billing.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        gstRate REAL NOT NULL,
        description TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices(
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        customerName TEXT,
        customerPhone TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoice_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceId TEXT NOT NULL,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (invoiceId) REFERENCES invoices (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
  }

  // Product operations
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toMap());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product?> getProduct(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Product.fromMap(maps.first);
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Invoice operations
  Future<void> insertInvoice(Invoice invoice) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('invoices', {
        'id': invoice.id,
        'date': invoice.date.toIso8601String(),
        'customerName': invoice.customerName,
        'customerPhone': invoice.customerPhone,
      });

      for (var item in invoice.items) {
        await txn.insert('invoice_items', {
          'invoiceId': invoice.id,
          'productId': item.product.id,
          'quantity': item.quantity,
        });
      }
    });
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> invoiceMaps = await db.query('invoices');

    List<Invoice> invoices = [];
    for (var invoiceMap in invoiceMaps) {
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [invoiceMap['id']],
      );

      List<InvoiceItem> items = [];
      for (var itemMap in itemMaps) {
        final product = await getProduct(itemMap['productId']);
        if (product != null) {
          items.add(InvoiceItem(
            product: product,
            quantity: itemMap['quantity'],
          ));
        }
      }

      invoices.add(Invoice(
        id: invoiceMap['id'],
        date: DateTime.parse(invoiceMap['date']),
        items: items,
        customerName: invoiceMap['customerName'],
        customerPhone: invoiceMap['customerPhone'],
      ));
    }
    return invoices;
  }

  Future<void> deleteInvoice(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      // First delete all invoice items
      await txn.delete(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [id],
      );
      // Then delete the invoice
      await txn.delete(
        'invoices',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }
}
