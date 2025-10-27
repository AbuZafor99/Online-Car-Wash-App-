class BookingResponseModel {
  final String id;
  final String user;
  final String bookingType;
  final String licensePlate;
  final String? carPhotoUrl;
  final LocationResponse location;
  final String vehicle;
  final List<BookingDateResponse> dates;
  final double price;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingResponseModel({
    required this.id,
    required this.user,
    required this.bookingType,
    required this.licensePlate,
    this.carPhotoUrl,
    required this.location,
    required this.vehicle,
    required this.dates,
    required this.price,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      bookingType: json['bookingType'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      carPhotoUrl: json['car_photo'],
      location: LocationResponse.fromJson(json['location'] ?? {}),
      vehicle: json['vehicle'] ?? '',
      dates:
          (json['dates'] as List?)
              ?.map((d) => BookingDateResponse.fromJson(d))
              .toList() ??
          [],
      price: (json['price'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'bookingType': bookingType,
      'licensePlate': licensePlate,
      'car_photo': carPhotoUrl,
      'location': location.toJson(),
      'vehicle': vehicle,
      'dates': dates.map((d) => d.toJson()).toList(),
      'price': price,
      'payment_status': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class LocationResponse {
  final String address;
  final double lat;
  final double lng;

  LocationResponse({
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      address: json['address'] ?? '',
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'lat': lat, 'lng': lng};
  }
}

class BookingDateResponse {
  final String id;
  final DateTime date;
  final String slot;
  final String washType;

  BookingDateResponse({
    required this.id,
    required this.date,
    required this.slot,
    required this.washType,
  });

  factory BookingDateResponse.fromJson(Map<String, dynamic> json) {
    return BookingDateResponse(
      id: json['_id'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      slot: json['slot'] ?? '',
      washType: json['wash_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'slot': slot,
      'wash_type': washType,
    };
  }
}
