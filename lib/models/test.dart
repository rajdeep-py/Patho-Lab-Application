import 'package:flutter/foundation.dart';

@immutable
class LabTest {
  final String id;
  final String name;
  final String category;
  final double price;
  final String photoUrl;
  final bool isActive;
  final String description;
  final List<String> parameters;
  final String precautions;
  final String sampleCollectionFlow;
  final String deliveryReportFlow;

  const LabTest({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.photoUrl,
    this.isActive = true,
    required this.description,
    required this.parameters,
    required this.precautions,
    required this.sampleCollectionFlow,
    required this.deliveryReportFlow,
  });

  LabTest copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? photoUrl,
    bool? isActive,
    String? description,
    List<String>? parameters,
    String? precautions,
    String? sampleCollectionFlow,
    String? deliveryReportFlow,
  }) {
    return LabTest(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      precautions: precautions ?? this.precautions,
      sampleCollectionFlow: sampleCollectionFlow ?? this.sampleCollectionFlow,
      deliveryReportFlow: deliveryReportFlow ?? this.deliveryReportFlow,
    );
  }

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      photoUrl: json['photoUrl'] as String,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String,
      parameters: List<String>.from(json['parameters'] as List),
      precautions: json['precautions'] as String,
      sampleCollectionFlow: json['sampleCollectionFlow'] as String,
      deliveryReportFlow: json['deliveryReportFlow'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'photoUrl': photoUrl,
      'isActive': isActive,
      'description': description,
      'parameters': parameters,
      'precautions': precautions,
      'sampleCollectionFlow': sampleCollectionFlow,
      'deliveryReportFlow': deliveryReportFlow,
    };
  }
}
