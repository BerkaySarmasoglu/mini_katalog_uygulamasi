import 'package:flutter/material.dart';
import 'package:mini_katalog_uygulamasi/models/cart_model.dart';
import '/models/product_model.dart';
import '/models/cart_model.dart';

class ProductDetailScreen extends StatelessWidget {
  // 1. Değişkeni tanımlıyoruz
  final Product product;

  // 2. Yapıcı metodu (Constructor) güncelliyoruz - 'product' parametresini zorunlu hale getiriyoruz
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          product.title, // Seçilen ürünün adını başlığa yazdırıyoruz
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        // İçeriğin taşmaması için kaydırılabilir yapıyoruz [cite: 47]
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[100],
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.devices, size: 100, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fiyat Bilgisi
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Ürün Başlığı
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ürün Açıklaması (Description) [cite: 80]
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),

                  // Specifications Başlığı
                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // Özellikler Satırı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSpecItem('Size', '3.3 inches'),
                      _buildSpecItem('Audio', '360-degree'),
                      _buildSpecItem('Colors', '5 colors'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final existingItemIndex = cartItems.indexWhere(
                          (item) => item.product.id == product.id,
                        );

                        if (existingItemIndex != -1) {
                          // Ürün zaten sepetteyse miktarını 1 artır
                          cartItems[existingItemIndex].quantity++;
                        } else {
                          // Ürün sepette yoksa listeye miktar 1 olarak yeni kayıt ekle
                          cartItems.add(
                            CartItem(product: product, quantity: 1),
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} sepete eklendi!'),
                            duration: const Duration(seconds: 2),
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
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildSpecItem(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ],
  );
}
