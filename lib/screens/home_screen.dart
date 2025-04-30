import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import 'new_invoice_screen.dart';
import 'product_list_screen.dart';
import 'invoice_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GST Billing App'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            'New Invoice',
            Icons.receipt,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewInvoiceScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Products',
            Icons.inventory,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProductListScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Invoice History',
            Icons.history,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const InvoiceHistoryScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Reports',
            Icons.analytics,
            () {
              // TODO: Implement reports screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reports feature coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
