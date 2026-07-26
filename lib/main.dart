import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const TatchiFashionApp());
}

class TatchiFashionApp extends StatelessWidget {
  const TatchiFashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تاتشي فاشن',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HomeScreen(),
    );
  }
}

// ----------------------------------------------------
// الشاشة الرئيسية (Home Screen)
// ----------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrency = 'YER'; // 'YER' (ريال يمني) أو 'SAR' (ريال سعودي)

  List<Map<String, dynamic>> products = [
    {
      'title': 'فستان نسائي راقي للمناسبات',
      'priceYER': 15000,
      'priceSAR': 220,
      'category': 'نسائي',
      'isNew': true,
      'imageFile': null,
    },
    {
      'title': 'طقم أطفال بناتي صيفي',
      'priceYER': 8500,
      'priceSAR': 120,
      'category': 'أطفال',
      'isNew': false,
      'imageFile': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'تاتشي فاشن',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          // مفتاح التحويل بين العملتين
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10.0),
            child: ToggleButtons(
              isSelected: [selectedCurrency == 'YER', selectedCurrency == 'SAR'],
              onPressed: (index) {
                setState(() {
                  selectedCurrency = index == 0 ? 'YER' : 'SAR';
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.pink,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 30),
              children: const [
                Text('ر.ي', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Text('ر.س', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // زر لوحة التحكم لإضافة عرض من الاستوديو
          IconButton(
            icon: const Icon(Icons.add_a_photo, color: Colors.pink),
            onPressed: () async {
              final newProduct = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
              if (newProduct != null) {
                setState(() {
                  products.insert(0, newProduct);
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بانر العروض
            Container(
              margin: const EdgeInsets.all(12),
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'تاتشي فاشن 🌟',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'أحدث تشكيلات الأزياء النسائية والأطفال',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'أحدث العروض والمنتجات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // شبكة العروض
            GridView.builder(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    final price = selectedCurrency == 'YER' ? product['priceYER'] : product['priceSAR'];
    final currencySymbol = selectedCurrency == 'YER' ? 'ر.ي' : 'ر.س';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: product,
              initialCurrency: selectedCurrency,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, spreadRadius: 2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: product['imageFile'] != null
                      ? Image.file(product['imageFile'], fit: BoxFit.cover)
                      : const Icon(Icons.checkroom, size: 50, color: Colors.pink),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$price $currencySymbol',
                    style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 14),
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

// ----------------------------------------------------
// شاشة تفاصيل العرض والحجز عبر الواتساب
// ----------------------------------------------------
class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final String initialCurrency;

  const ProductDetailScreen({super.key, required this.product, required this.initialCurrency});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late String selectedCurrency;
  String selectedSize = 'M';

  final List<String> sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> whatsappNumbers = ['967777470505', '967782303300', '967783555883'];

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.initialCurrency;
  }

  Future<void> sendToWhatsApp(String phoneNumber) async {
    final price = selectedCurrency == 'YER' ? widget.product['priceYER'] : widget.product['priceSAR'];
    final currencySymbol = selectedCurrency == 'YER' ? 'ر.ي' : 'ر.س';

    final String message = '''
مرحباً تاتشي فاشن 👋
أرغب في حجز القطعة التالية:
📌 *المنتج:* ${widget.product['title']}
📏 *المقاس:* $selectedSize
💰 *السعر:* $price $currencySymbol
---
يرجى تأكيد الحجز وتزويدي بالتفاصيل.
''';

    final Uri url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void showWhatsAppSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('اختر رقم الواتساب لإكمال الحجز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('خدمة العملاء (777470505)'),
                onTap: () { Navigator.pop(context); sendToWhatsApp(whatsappNumbers[0]); },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('خدمة العملاء (782303300)'),
                onTap: () { Navigator.pop(context); sendToWhatsApp(whatsappNumbers[1]); },
              ),
              ListTile(
                leading: const Icon(Icons.chat, color: Colors.green),
                title: const Text('خدمة العملاء (783555883)'),
                onTap: () { Navigator.pop(context); sendToWhatsApp(whatsappNumbers[2]); },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final price = selectedCurrency == 'YER' ? widget.product['priceYER'] : widget.product['priceSAR'];
    final currencySymbol = selectedCurrency == 'YER' ? 'ر.ي' : 'ر.س';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل القطعة', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 320,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: widget.product['imageFile'] != null
                        ? Image.file(widget.product['imageFile'], fit: BoxFit.cover)
                        : const Icon(Icons.checkroom, size: 80, color: Colors.pink),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.product['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('$price $currencySymbol', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('اختر المقاس:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: sizes.map((size) {
                            final isSelected = selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.pink : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: showWhatsAppSelector,
              icon: const Icon(Icons.whatsapp, color: Colors.white),
              label: const Text('حجز مباشر عبر الواتساب', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// لوحة التحكم وإضافة العروض من الاستوديو
// ----------------------------------------------------
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File? _selectedImage;
  final _titleController = TextEditingController();
  final _priceYERController = TextEditingController();
  final _priceSARController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عرض جديد'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.shade200, width: 2),
                ),
                child: _selectedImage != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_selectedImage!, fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.pink),
                          SizedBox(height: 8),
                          Text('اضغط هنا لاختيار صورة العرض من الاستوديو'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'اسم القطعة / العرض', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceYERController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'السعر (ريال يمني)', suffixText: 'ر.ي', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _priceSARController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'السعر (ريال سعودي)', suffixText: 'ر.س', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty) return;
                  final newProduct = {
                    'title': _titleController.text,
                    'priceYER': double.tryParse(_priceYERController.text) ?? 0,
                    'priceSAR': double.tryParse(_priceSARController.text) ?? 0,
                    'category': 'عروض',
                    'isNew': true,
                    'imageFile': _selectedImage,
                  };
                  Navigator.pop(context, newProduct);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const Text('نشر العرض في التطبيق', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

