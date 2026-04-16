import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // id null gelirse veya yoksa '0' ata
      id: json['id']?.toString() ?? '0',

      // title null gelirse 'İsimsiz Ürün' ata
      title: json['title'] ?? 'İsimsiz Ürün',

      // description null gelirse varsayılan metin ata
      description: json['description'] ?? 'Bu ürün için açıklama bulunmuyor.',

      // Fiyat kısmı biraz daha hassas, null veya hatalı string gelme ihtimaline karşı tryParse
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,

      // imageUrl'i daha önce çözmüştük
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse('https://wantapi.com/products.php');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Veriyi direkt List olarak değil, ne geldiğini bilmediğimiz için 'dynamic' olarak decode ediyoruz
      final decodedData = jsonDecode(response.body);

      List<dynamic> targetList = [];

      // Durum 1: Eğer API direkt bir liste döndürdüyse (İlk varsayımımız)
      if (decodedData is List) {
        targetList = decodedData;
      }
      // Durum 2: Eğer API bir Map (Obje) döndürdüyse (Senin aldığın hatadaki durum)
      else if (decodedData is Map) {
        // Genelde veriler 'products', 'data' veya 'items' gibi bir anahtarın içinde liste olarak tutulur.
        if (decodedData.containsKey('products')) {
          targetList = decodedData['products'];
        } else if (decodedData.containsKey('data')) {
          targetList = decodedData['data'];
        } else {
          // Eğer anahtar adını tam bilemiyorsak, map içindeki ilk 'List' olan değeri bulmaya çalışalım
          for (var value in decodedData.values) {
            if (value is List) {
              targetList = value;
              break;
            }
          }
        }
      }

      // Bulduğumuz asıl listeyi Product modeline dönüştürüyoruz
      return targetList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Veri çekilemedi: Sunucu ${response.statusCode} hatası döndürdü.',
      );
    }
  } catch (error) {
    throw Exception('Ağ hatası oluştu: $error');
  }
}
