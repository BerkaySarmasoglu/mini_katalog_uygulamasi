import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0, // AppBar'ın altındaki gölgeyi kaldırır
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () {
              // Sepet sayfasına geçiş (Route yönlendirmesi)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ana Sayfa İskeleti'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Detay sayfasına geçiş simülasyonu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductDetailScreen(),
                  ),
                );
              },
              child: const Text('Örnek Ürüne Git'),
            ),
          ],
        ),
      ),
    );
  }
}
