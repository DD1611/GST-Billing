# GST Billing Application

A Flutter-based mobile application for managing products, generating invoices, and handling GST calculations.

## Features

- **Product Management**
  - Add, view, and delete products
  - Set product name, price, GST rate, and category
  - Automatic calculation of total price including GST

- **Invoice Generation**
  - Create new invoices with multiple products
  - Add customer details (optional)
  - Automatic calculation of:
    - Subtotal
    - CGST (Central GST)
    - SGST (State GST)
    - Total amount

- **Invoice History**
  - View all past invoices
  - Detailed invoice breakdown
  - Delete invoices
  - Sort by date

## Screens

1. **Product List Screen**
   - Displays all products with their details
   - Add new products
   - Delete products with confirmation
   - Shows price and GST information

2. **Add Product Screen**
   - Form to add new products
   - Input validation
   - Real-time price calculation

3. **Invoice Generation Screen**
   - Select products and quantities
   - Add customer details
   - Preview invoice before saving
   - Automatic GST calculations

4. **Invoice History Screen**
   - List of all invoices
   - Expandable invoice details
   - Delete invoices with confirmation
   - View complete invoice breakdown

## Technical Details

- Built with Flutter
- Uses SQLite for local data storage
- Implements Provider for state management
- Follows Material Design guidelines

## Getting Started

1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## Dependencies

- `flutter_slidable`: For swipeable list items
- `intl`: For date formatting
- `uuid`: For generating unique IDs
- `sqflite`: For SQLite database operations
- `provider`: For state management

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
