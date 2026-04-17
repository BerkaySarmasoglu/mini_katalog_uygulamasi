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
                      title: const Text("Empty the Cart"),
                      content: const Text(
                        "All items in the cart will be removed. Are you sure?",
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text(
                            "Empty the Cart",
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
                                content: Text('Cart emptied successfully.'),
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
                'Empty the Cart',
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
                    padding: const EdgeInsets.all(
                      16,
                    ), // Sayfa kenarlarından boşluk
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final product = cartItem.product;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16.0,
                        ), // Kartlar arası boşluk
                        child: Container(
                          // ANA SAYFA İLE AYNI ÇERÇEVE VE GÖLGE KALIBI
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // STANDART GÖRSEL ALANI (Açık Gri Arka Plan)
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(
                                      11,
                                    ), // Çerçeveye tam uyum
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.devices,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),

                              // METİN VE KONTROL ALANI
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${(product.price * cartItem.quantity).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // MİKTAR KONTROLLERİ
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 22,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (cartItem.quantity > 1) {
                                            cartItem.quantity--;
                                          } else {
                                            cartItems.removeAt(index);
                                          }
                                        });
                                      },
                                    ),
                                    Text(
                                      '${cartItem.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        size: 22,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          cartItem.quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                            content: Text('Directed to payment gateway.'),
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
