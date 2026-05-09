class LabTest {
  final String id;
  final String name;
  final String category;
  final double price;
  final String photoUrl;
  final String detailedDescription;
  final List<String> parameters;
  final List<String> precautions;
  final String sampleCollectionType;
  final String sampleCollectionTime;
  final String reportDeliveryTime;

  LabTest({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.photoUrl,
    required this.detailedDescription,
    required this.parameters,
    required this.precautions,
    required this.sampleCollectionType,
    required this.sampleCollectionTime,
    required this.reportDeliveryTime,
  });

  LabTest copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? photoUrl,
    String? detailedDescription,
    List<String>? parameters,
    List<String>? precautions,
    String? sampleCollectionType,
    String? sampleCollectionTime,
    String? reportDeliveryTime,
  }) {
    return LabTest(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      parameters: parameters ?? this.parameters,
      precautions: precautions ?? this.precautions,
      sampleCollectionType: sampleCollectionType ?? this.sampleCollectionType,
      sampleCollectionTime: sampleCollectionTime ?? this.sampleCollectionTime,
      reportDeliveryTime: reportDeliveryTime ?? this.reportDeliveryTime,
    );
  }
}
