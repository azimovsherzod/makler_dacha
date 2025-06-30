import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class DachaModel extends Equatable {
  DachaModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.deletedAt,
    required this.deleted,
    required this.name,
    required this.address,
    required this.bedsCount,
    required this.hallCount,
    required this.price,
    required this.description,
    required this.phone,
    this.transactionType = "rent",
    this.propertyType = "dacha",
    required this.popularPlace,
    required this.clientType,
    required this.user,
    required this.facilities,
    required this.images,
  });

  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool isActive;
  final dynamic deletedAt;
  final bool deleted;
  final String name;
  final String address;
  final dynamic bedsCount;
  final dynamic hallCount;
  final dynamic price;
  final dynamic description;
  final dynamic phone;
  final String transactionType;
  final String propertyType;
  final dynamic popularPlace;
  final dynamic clientType;
  final dynamic user;
  final List<dynamic> facilities;
  List<dynamic> images;

  DachaModel copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    dynamic deletedAt,
    bool? deleted,
    String? name,
    String? address,
    dynamic bedsCount,
    dynamic hallCount,
    dynamic price,
    dynamic description,
    dynamic phone,
    String? transactionType,
    String? propertyType,
    dynamic popularPlace,
    dynamic clientType,
    dynamic user,
    List<dynamic>? facilities,
    List<dynamic>? images,
  }) {
    return DachaModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      deletedAt: deletedAt ?? this.deletedAt,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      address: address ?? this.address,
      bedsCount: bedsCount ?? this.bedsCount,
      hallCount: hallCount ?? this.hallCount,
      price: price ?? this.price,
      description: description ?? this.description,
      phone: phone ?? this.phone,
      transactionType: transactionType ?? this.transactionType,
      propertyType: propertyType ?? this.propertyType,
      popularPlace: popularPlace ?? this.popularPlace,
      clientType: clientType ?? this.clientType,
      user: user ?? this.user,
      facilities: facilities ?? this.facilities,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'phone': phone.toString(),
      'hall_count': hallCount,
      'beds_count': bedsCount,
      'transaction_type': transactionType.isEmpty ? 'rent' : transactionType,
      'facilities': facilities,
      'popular_place': popularPlace,
      'client_type': clientType,
      // 'address': address,
      'property_type': propertyType.isEmpty ? 'dacha' : propertyType,
      'images': images.map((e) {
        if (e is Map && e.containsKey('image')) {
          return e['image'];
        }
        return e.toString();
      }).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'deleted_at':
          deletedAt != null ? DateFormat('yyyy-MM-dd').format(deletedAt) : null,
      'deleted': deleted,
      'user': user,
    };
  }

  factory DachaModel.fromJson(Map<String, dynamic> json) {
    return DachaModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      phone: json['phone']?.toString() ?? '',
      hallCount: json['hall_count'] ?? 0,
      bedsCount: json['beds_count'] ?? 0,
      transactionType: (json['transaction_type'] ?? 'rent').isEmpty
          ? 'rent'
          : json['transaction_type'],
      images: (json['images'] as List<dynamic>?)?.map((e) {
            if (e is Map && e.containsKey('image')) {
              return e['image'];
            }
            return e.toString();
          }).toList() ??
          [],
      facilities: List<int>.from(json['facilities'] ?? []),
      address: json['address'] ?? '',
      propertyType: (json['property_type'] ?? 'dacha').isEmpty
          ? 'dacha'
          : json['property_type'],
      popularPlace: json['popular_place'] ?? 0,
      clientType: json['client_type'] ?? 0,
      user: json['user'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isActive: json['is_active'] ?? false,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      deleted: json['deleted'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        isActive,
        deletedAt,
        deleted,
        name,
        address,
        bedsCount,
        hallCount,
        price,
        description,
        phone,
        transactionType,
        propertyType,
        popularPlace,
        clientType,
        user,
        facilities,
        images,
      ];
}
