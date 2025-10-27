class VehicleImage {
  final String url;
  final String publicId;

  VehicleImage({required this.url, required this.publicId});

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      url: json['url'] ?? '',
      publicId: json['public_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'public_id': publicId};
  }
}

class Vehicle {
  final String id;
  final String vehicleName;
  final String washType;
  final VehicleImage vehicleImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.vehicleName,
    required this.washType,
    required this.vehicleImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['_id'] ?? '',
      vehicleName: json['vehicleName'] ?? '',
      washType: json['washType'] ?? '',
      vehicleImage: VehicleImage.fromJson(json['vehicleImage'] ?? {}),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime _parseDateTime(dynamic dateString) {
    if (dateString == null) return DateTime.now();
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleName': vehicleName,
      'washType': washType,
      'vehicleImage': vehicleImage.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class VehicleResponse {
  final List<Vehicle> vehicles;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  VehicleResponse({
    required this.vehicles,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) {
    return VehicleResponse(
      vehicles:
          (json['vehicles'] as List<dynamic>?)
              ?.map((vehicleJson) => Vehicle.fromJson(vehicleJson))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicles': vehicles.map((vehicle) => vehicle.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
