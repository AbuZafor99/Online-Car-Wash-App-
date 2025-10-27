import 'dart:io';

class BookingRequestModel {
  final String userId;
  final String bookingType;
  final String licensePlate;
  final LocationData location;
  final String vehicleId;
  final List<BookingDateSlot> dates;
  final File? carPhoto;

  BookingRequestModel({
    required this.userId,
    required this.bookingType,
    required this.licensePlate,
    required this.location,
    required this.vehicleId,
    required this.dates,
    this.carPhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'bookingType': bookingType,
      'licensePlate': licensePlate,
      'location': location.toJson(),
      'vehicle': vehicleId,
      'dates': dates.map((d) => d.toJson()).toList(),
    };
  }
}

class LocationData {
  final String address;
  final double lat;
  final double lng;

  LocationData({required this.address, required this.lat, required this.lng});

  Map<String, dynamic> toJson() {
    return {'address': address, 'lat': lat, 'lng': lng};
  }

  String toJsonString() {
    return '{"address": "$address", "lat": $lat, "lng": $lng}';
  }
}

class BookingDateSlot {
  final String date; // Format: "2025-09-12T00:00:00.000Z"
  final String slot; // Format: "10:00-12:00"
  final String washTypeId;

  BookingDateSlot({
    required this.date,
    required this.slot,
    required this.washTypeId,
  });

  Map<String, dynamic> toJson() {
    return {'date': date, 'slot': slot, 'wash_type': washTypeId};
  }

  String toJsonString() {
    return '{"date": "$date", "slot": "$slot", "wash_type": "$washTypeId"}';
  }
}
