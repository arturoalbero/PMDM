import 'package:healthys_app/domain/entities/producte.dart';

class Beguda extends Producte {
  final bool isAlcoholic;
  Beguda({
    required super.id,
    required super.name,
    required super.description,
    super.tipus,
    required this.isAlcoholic,
    required super.allergens,
    required super.price,
    required super.calories,
    super.additionalInfo,
    super.img,
  });
  // Constructor de factoria a partir d'un JSON
  factory Beguda.fromJson(Map<String, dynamic> json, urlBase) {
    return Beguda(
      id: json['id'],
      name: json['name'] ?? "-",
      description: json['description'] ?? "-",
      tipus: json["tipus"] ?? "-",
      isAlcoholic: json['isAlcoholic'] ?? false,
      allergens: List<String>.from(json["allergens"]),
      price: (json['price'] as num).toDouble(),
      calories: json['calories'],
      additionalInfo: json['additionalInfo'],
      img: json['img'] != ""
          ? "$urlBase/${json['img']}"
          : "$urlBase/not_found.png",
    );
  }

  @override
  String toString() {
    return ' Beguda(name: $name, description: $description, alcoholica: $isAlcoholic,tipus: $tipus, allergens: $allergens, price: $price, calories: $calories, additionalInfo: $additionalInfo)';
  }

  @override
  String toStringSmart() {
    return '''\n\n\x1B[32m$name
  \x1B[36m$description\n
  \x1B[92m${isAlcoholic ? "Beguda alcohòlica" : "Beguda sense alcohol"}
  \x1B[92mtipus de beguda: \x1B[0m$tipus
  ${allergens.isEmpty ? "\x1B[92mNo conté cap al·lèrgens" : "\x1B[92mAl·lèrgens del producte: \x1B[0m${allergens.join(', ')}"} 
  \x1B[92mpreu: \x1B[0m$price€
  \x1B[92mcalories: \x1B[0m$calories
  \x1B[92mInformació addicional: \x1B[0m$additionalInfo
  \x1B[92murl a la imatge: \x1B[0m$img''';
  }

  @override
  ProductsType getClass() {
    return ProductsType.beguda;
  }
}
