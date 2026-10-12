import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Spec {
  final String label, value;
  const Spec(this.label, this.value);
  
  factory Spec.fromMap(Map m) => Spec(
        (m['label'] ?? '').toString().trim(),
        (m['value'] ?? '').toString().trim(),
      );
}

class Vehicle {
  final String id, name, image, year, make, model, detail, location, carfaxUrl, status;
  final List<String> images, description;
  final List<Spec> specifications;
  final num? price;     
  final num? mileage;   
  final bool featured;
  final int createdAt;

  const Vehicle({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.year,
    required this.make,
    required this.model,
    this.price,
    this.mileage,
    required this.detail,
    required this.location,
    required this.description,
    required this.specifications,
    required this.carfaxUrl,
    required this.status,
    required this.featured,
    required this.createdAt,
  });

  static String s(dynamic x) => x == null ? '' : x.toString().trim();
  static num? n(dynamic x) => x == null ? null : x is num ? x : num.tryParse(x.toString().trim());

  factory Vehicle.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    
    // Extrae lista de imágenes
    final rawImages = (d['images'] as List? ?? const [])
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Si viene un campo 'image' individual, lo incluye en la lista de imágenes si no está
    final singleImage = s(d['image']);
    if (singleImage.isNotEmpty && !rawImages.contains(singleImage)) {
      rawImages.insert(0, singleImage);
    }

    final year = s(d['year']), make = s(d['make']), model = s(d['model']);

    final fixed = <Spec>[
      Spec('Engine', s(d['engine'])),
      Spec('Horsepower', s(d['horsepower'])),
      Spec('Transmission', s(d['transmission'])),
      Spec('Drivetrain', s(d['drivetrain'])),
      Spec('Exterior', s(d['exteriorColor'])),
      Spec('Interior', s(d['interiorColor'])),
      Spec('Fuel', s(d['fuel'])),
      Spec('Body', s(d['bodyType'])),
      Spec('VIN', s(d['vin'])),
      Spec('Stock #', s(d['stock'])),
    ].where((x) => x.value.isNotEmpty).toList();

    final custom = (d['specifications'] as List? ?? const [])
        .whereType<Map>()
        .map(Spec.fromMap)
        .where((x) => x.label.isNotEmpty && x.value.isNotEmpty);

    final p = n(d['price']), m = n(d['mileage']);

    // Resguardo por si la lista viene totalmente vacía o con URLs inválidas/rotas
    final String defaultImg = rawImages.isNotEmpty 
        ? rawImages.first 
        : 'assets/hero-red-ferrari.webp';

    return Vehicle(
      id: doc.id,
      name: s(d['name']).isNotEmpty ? s(d['name']) : [year, make, model].where((e) => e.isNotEmpty).join(' '),
      image: defaultImg,
      images: rawImages.isNotEmpty ? rawImages : [defaultImg],
      year: year,
      make: make,
      model: model,
      price: (p != null && p > 0) ? p : null,
      mileage: (m != null && m > 0) ? m : null,
      detail: s(d['exteriorColor']),
      location: s(d['location']).isNotEmpty ? s(d['location']) : 'Miami, Florida',
      description: s(d['description']).split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList(),
      specifications: [...fixed, ...custom],
      carfaxUrl: s(d['carfaxUrl']),
      status: s(d['status']).isNotEmpty ? s(d['status']) : 'available',
      featured: d['featured'] == true,
      createdAt: n(d['createdAt'])?.toInt() ?? 0,
    );
  }

  String get priceLabel => price == null ? 'On request' : '\$${NumberFormat('#,##0', 'en_US').format(price)}';
  String get mileageLabel => mileage == null ? '' : '${NumberFormat('#,##0', 'en_US').format(mileage)} mi';
}