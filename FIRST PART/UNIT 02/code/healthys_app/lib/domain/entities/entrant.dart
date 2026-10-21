import 'package:healthys_app/domain/entities/producte.dart';

class Entrant extends Producte {
  final List<String>? dietType; // Tipus de dieta (ex: vegà, sense gluten, etc.)
  Entrant({
    required super.id,
    required super.name,
    required super.description,
    super.tipus,
    required super.allergens,
    required super.price,
    required super.calories,
    this.dietType,
    super.additionalInfo,
    super.img,
  });

  // Constructor de factoria a partir d'un JSON
  // Arguments:
  //  - el JSON en qüestió
  //  - L'adreça URL base, per construir la URL de la imatge completa
  factory Entrant.fromJson(Map<String, dynamic> json, String urlBase) {
    return Entrant(
      id: json['id'],
      name: json['name'] ?? "-",
      description: json['description'] ?? "-",
      tipus: json["tipus"] ?? "-",
      allergens: List<String>.from(json["allergens"]),
      price: (json['price'] as num).toDouble(),
      calories: json['calories'],
      dietType: List<String>.from(json["dietType"]),
      additionalInfo: json['additionalInfo'],
      img: json['img'] != ""
          ? "$urlBase/${json['img']}"
          : "$urlBase/not_found.png",
    );
  }

  @override
  String toString() {
    return 'Entrant(name: $name, description: $description, tipus: $tipus, allergens: $allergens, price: $price, calories: $calories, dietType: $dietType, additionalInfo: $additionalInfo)';
  }

  @override
  String toStringSmart() {
    return '''\n\n\x1B[32m$name
  \x1B[36m$description\n
  \x1B[92mtipus de plat: \x1B[0m$tipus
  ${(dietType?.isEmpty ?? true) ? "\x1B[92mIdeal per tot tipus de dieta" : "\x1B[92mIdeal per a dietes: \x1B[0m${dietType!.join(', ')}"} 
  ${allergens.isEmpty ? "\x1B[92mNo conté cap al·lèrgens" : "\x1B[92mAl·lèrgens del producte: \x1B[0m${allergens.join(', ')}"} 
  \x1B[92mpreu: \x1B[0m$price€
  \x1B[92mcalories: \x1B[0m$calories
  \x1B[92mInformació addicional: \x1B[0m$additionalInfo
  \x1B[92murl a la imatge: \x1B[0m$img''';
  }

  @override
  ProductsType getClass() {
    return ProductsType.entrant;
  }
}
