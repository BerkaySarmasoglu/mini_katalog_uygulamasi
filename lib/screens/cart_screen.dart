import 'package:flutter/material.dart';
import '/models/cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (cartItems.isNotEmpty) // Sadece sepet doluysa butonu göster
            TextButton(
              onPressed: () {
                // Onay kutusu (Dialog) göstererek işlemi doğrula
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Sepeti Boşalt"),
                      content: const Text(
                        "Sepetteki tüm ürünler silinecek. Emin misiniz?",
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Vazgeç"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text(
                            "Sepeti Boşalt",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // Listeyi temizle ve arayüzü yenile
                            setState(() {
                              cartItems.clear();
                            });
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sepet tamamen boşaltıldı.'),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Sepeti Boşalt',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty', //
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final product = cartItem.product;

                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                        title: Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Fiyatı o anki miktar ile çarparak gösteriyoruz
                        subtitle: Text(
                          '\$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.blue),
                        ),

                        // Miktar kontrol alanı (+ / - butonları)
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (cartItem.quantity > 1) {
                                    // Miktar 1'den büyükse sadece azalt
                                    cartItem.quantity--;
                                  } else {
                                    // Miktar 1 ise listeden tamamen çıkar
                                    cartItems.removeAt(index);
                                  }
                                });
                              },
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.black54,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Miktarı artır
                                  cartItem.quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Checkout Butonu Alanı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Satın alma simülasyonu çalıştı!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ), //
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
