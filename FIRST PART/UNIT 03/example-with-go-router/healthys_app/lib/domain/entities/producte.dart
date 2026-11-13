enum ProductsType { entrant, principal, beguda }

abstract class Producte {
  final String id; // id del producte
  final String name; // Nom del producte
  final String description; // Descripció amb ingredients
  final String? tipus;
  final List<String> allergens; // Alèrgens
  final double price; // Preu
  final int calories; // Calories
  final String? additionalInfo; // Qualsevol informació addicional
  final String? img;

  Producte({
    required this.id,
    required this.name,
    required this.description,
    this.tipus,
    required this.allergens,
    required this.price,
    required this.calories,
    this.additionalInfo,
    this.img,
  });

  @override
  String toString();
  String toStringSmart();
  ProductsType getClass();
}
