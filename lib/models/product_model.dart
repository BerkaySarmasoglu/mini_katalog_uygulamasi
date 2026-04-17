import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final Map<String, String> specs;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String rawPrice = json['price']?.toString() ?? '0';
    String cleanPrice = rawPrice.replaceAll(RegExp(r'[^0-9.]'), '');

    // 1. Başlangıçta boş ve temiz bir Map oluşturuyoruz (Asla null olmaması garanti)
    Map<String, String> parsedSpecs = {};

    // 2. Gelen 'specs' verisinin null olmadığını VE gerçekten bir Obje (Map) olduğunu kontrol ediyoruz
    if (json['specs'] != null && json['specs'] is Map) {
      // 3. Tip uyuşmazlığını engellemek için önce dynamic olarak alıyoruz
      final Map<dynamic, dynamic> rawSpecs = json['specs'];

      rawSpecs.forEach((key, value) {
        // 4. İçerideki anahtar veya değerlerden biri bozuk/null ise uygulamayı çökertmeden atlıyoruz
        if (key != null && value != null) {
          String formattedKey = key.toString();
          if (formattedKey.isNotEmpty) {
            formattedKey =
                formattedKey[0].toUpperCase() + formattedKey.substring(1);
          }
          // Veriyi güvenle String'e çevirip listemize ekliyoruz
          parsedSpecs[formattedKey] = value.toString();
        }
      });
    }

    return Product(
      id: json['id']?.toString() ?? '0',
      // Hem 'name' hem 'title' gelme ihtimaline karşı çifte güvenlik:
      title: json['name'] ?? json['title'] ?? 'İsimsiz Ürün',
      description: json['description'] ?? 'Bu ürün için açıklama bulunmuyor.',
      price: double.tryParse(cleanPrice) ?? 0.0,
      imageUrl: json['image'] ?? 'https://via.placeholder.com/150',
      specs: parsedSpecs,
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
