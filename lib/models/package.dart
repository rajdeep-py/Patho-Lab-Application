class LabPackage {
  final String id;
  final String name;
  final double price;
  final String description;
  final List<String> labTestIds;
  final String sampleCollectionTime;
  final String reportDeliveryTime;
  final String photoUrl;

  LabPackage({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.labTestIds,
    required this.sampleCollectionTime,
    required this.reportDeliveryTime,
    required this.photoUrl,
  });

  LabPackage copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    List<String>? labTestIds,
    String? sampleCollectionTime,
    String? reportDeliveryTime,
    String? photoUrl,
  }) {
    return LabPackage(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      labTestIds: labTestIds ?? this.labTestIds,
      sampleCollectionTime: sampleCollectionTime ?? this.sampleCollectionTime,
      reportDeliveryTime: reportDeliveryTime ?? this.reportDeliveryTime,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
