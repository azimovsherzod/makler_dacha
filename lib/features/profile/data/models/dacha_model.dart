import 'package:equatable/equatable.dart';

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
    required this.transactionType,
    required this.propertyType,
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
      'phone': phone,
      'hall_count': hallCount,
      'beds_count': bedsCount,
      'transaction_type': transactionType.isNotEmpty
          ? transactionType
          : "rent", // Default value
      'facilities': facilities,
      'popular_place': popularPlace,
      'client_type': clientType,
      'address': address,
      'property_type':
          propertyType.isNotEmpty ? propertyType : "dacha", // Default value
      'images': images,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'deleted_at': deletedAt is DateTime
          ? deletedAt.toIso8601String().split('T').first
          : deletedAt, // Check type
      'deleted': deleted,
      'user': user,
    };
  }

  factory DachaModel.fromJson(Map<String, dynamic> json) {
    return DachaModel(
      id: json["id"] ?? 0,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      isActive: json["is_active"] ?? false,
      deletedAt: json["deleted_at"],
      deleted: json["deleted"] ?? false,
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      bedsCount: json["beds_count"],
      hallCount: json["hall_count"],
      price: json["price"],
      description: json["description"],
      phone: json["phone"],
      transactionType: json["transaction_type"]?.isNotEmpty == true
          ? json["transaction_type"]
          : "rent",
      propertyType: json["property_type"] ?? "",
      popularPlace: json["popular_place"],
      clientType: json["client_type"],
      user: json["user"],
      facilities: json["facilities"] == null
          ? []
          : List<dynamic>.from(json["facilities"].map((x) {
              if (x is Map) {
                return Map<String, dynamic>.from(x);
              }
              return x;
            })),
      images: json["images"] == null
          ? []
          : List<dynamic>.from(json["images"].map((x) {
              if (x is Map) {
                return Map<String, dynamic>.from(x);
              }
              return x;
            })),
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
