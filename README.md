# Mini Katalog Uygulaması 📱

Bu proje, dinamik veri çekme ve sepet yönetimi özelliklerine sahip profesyonel bir mobil katalog uygulaması taslağıdır.

## 📝 Proje Açıklaması
Uygulama, bir API üzerinden ürün verilerini çekerek kullanıcıya sunar. Kullanıcılar ürünler arasında arama yapabilir, ürün detaylarını inceleyebilir ve ürünleri miktarlarıyla birlikte sepete ekleyip yönetebilirler. Proje boyunca temiz kod prensipleri ve etkili klasörleme mimarisi uygulanmıştır.

### Anahtar Özellikler:
* **Dinamik Veri Yönetimi:** `http` paketi kullanılarak gerçek zamanlı API entegrasyonu.
* **Arama ve Filtreleme:** Ürün ismiyle anlık arama yapabilme özelliği.
* **Gelişmiş Sepet Sistemi:** Ürün bazlı miktar artırma/azaltma, toplam fiyat hesaplama ve sepeti tek tuşla boşaltma.
* **Modern UI Tasarımı:** Standart çerçeve kalıpları, soft gölgeler ve pastel görsel alanları ile tutarlı kullanıcı arayüzü.
* **Sayfa Yönetimi:** `Navigator` ve `Route Arguments` ile sayfalar arası güvenli veri iletimi.

## 🛠️ Kullanılan Teknolojiler
* **Framework:** Flutter
* **Dil:** Dart
* **Flutter Sürümü:** 3.41.6
* **Paketler:** `http: ^1.1.0` (Ağ istekleri için)

## 📂 Proje Yapısı
```text
lib/
├── models/      # Product ve CartItem modelleri
├── screens/     # Home, Product Detail ve Cart ekranları
└── main.dart    # Uygulama giriş noktası
```

Projeyi yerel makinenizde test etmek ve çalıştırmak için aşağıdaki adımları sırasıyla izleyebilirsiniz:

1. **Depoyu Klonlayın:**
   Terminal veya komut satırını açarak projeyi bilgisayarınıza indirin.
   ```bash
   git clone https://github.com/BerkaySarmasoglu/mini_katalog_uygulamasi
   ```

2. **Proje Dizinine Gidin**
    Klonlama işlemi bittikten sonra projenin ana klasörüne geçiş yapın.
    ```bash
    cd mini_katalog_uygulamasi
    ```

3. **Bağımlılıkları Yükleyin**
    Projede kullanılan http gibi harici paketleri ve kütüphaneleri indirin.
    ```bash
    flutter pub get
    ```

4. **Uygulamayı başlatın**
    Bilgisayarınıza bağlı bir fiziksel cihazda veya açık olan bir emülatörde projeyi derleyip çalıştırın.
    ```bash
    flutter run
    ```