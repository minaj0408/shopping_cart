import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart UI',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingCartScreen(),
    );
  }
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Pullover', 'color': 'Black', 'size': 'L', 'price': 50, 'quantity': 1},
    {'name': 'T-Shirt', 'color': 'Gray', 'size': 'L', 'price': 30, 'quantity': 1},
    {'name': 'Sport Dress', 'color': 'Black', 'size': 'M', 'price': 45, 'quantity': 1},
  ];

  double getTotalAmount() {
    return cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  }

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void checkOut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Congratulations! Your checkout is successful!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = getTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Bag'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CartItem(
                      name: item['name'],
                      color: item['color'],
                      size: item['size'],
                      price: item['price'],
                      quantity: item['quantity'],
                      onIncrement: () => incrementQuantity(index),
                      onDecrement: () => decrementQuantity(index),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total amount: ${totalAmount.toStringAsFixed(2)}\$',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => checkOut(context),
              child: Text('CHECK OUT'),
              style: ElevatedButton.styleFrom(
                //primary: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String name;
  final String color;
  final String size;
  final int price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItem({
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/shirt.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('Color: $color', style: TextStyle(fontSize: 14)),
                  Text('Size: $size', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: Icon(Icons.remove_circle_outline),
                    ),
                    Text('$quantity'),
                    IconButton(
                      onPressed: onIncrement,
                      icon: Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                Text(
                  '${price * quantity}\$',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
