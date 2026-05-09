class Medicine {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String photoUrl;
  final String composition;
  final String manufacturer;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.photoUrl,
    required this.composition,
    required this.manufacturer,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? photoUrl,
    String? composition,
    String? manufacturer,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      photoUrl: photoUrl ?? this.photoUrl,
      composition: composition ?? this.composition,
      manufacturer: manufacturer ?? this.manufacturer,
    );
  }
}
