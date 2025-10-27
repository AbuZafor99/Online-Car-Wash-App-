class ScheduleSlotModel {
  final String id;
  final String day;
  final String slot1;
  final String slot2;
  final String slot3;
  final String slot4;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleSlotModel({
    required this.id,
    required this.day,
    required this.slot1,
    required this.slot2,
    required this.slot3,
    required this.slot4,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSlotModel(
      id: json['_id'] ?? '',
      day: json['day'] ?? '',
      slot1: json['slot_1'] ?? '',
      slot2: json['slot_2'] ?? '',
      slot3: json['slot_3'] ?? '',
      slot4: json['slot_4'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'day': day,
      'slot_1': slot1,
      'slot_2': slot2,
      'slot_3': slot3,
      'slot_4': slot4,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  List<String> get allSlots => [slot1, slot2, slot3, slot4];

  // Demo data for development
  static List<ScheduleSlotModel> getDemoData() {
    return [
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20ddd",
        day: "sat",
        slot1: "9:00 AM-10:00 AM",
        slot2: "10:00 AM-12:00 PM",
        slot3: "12:00 PM-2:00 PM",
        slot4: "2:00 PM-4:00 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20dde",
        day: "sun",
        slot1: "8:00 AM-10:00 AM",
        slot2: "10:00 AM-12:00 PM",
        slot3: "1:00 PM-3:00 PM",
        slot4: "3:00 PM-5:00 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20ddf",
        day: "mon",
        slot1: "9:00 AM-11:00 AM",
        slot2: "11:00 AM-1:00 PM",
        slot3: "2:00 PM-4:00 PM",
        slot4: "4:00 PM-6:00 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20de0",
        day: "tue",
        slot1: "8:30 AM-10:30 AM",
        slot2: "10:30 AM-12:30 PM",
        slot3: "1:30 PM-3:30 PM",
        slot4: "3:30 PM-5:30 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20de1",
        day: "wed",
        slot1: "9:00 AM-11:00 AM",
        slot2: "11:00 AM-1:00 PM",
        slot3: "2:00 PM-4:00 PM",
        slot4: "4:00 PM-6:00 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20de2",
        day: "thu",
        slot1: "8:00 AM-10:00 AM",
        slot2: "10:00 AM-12:00 PM",
        slot3: "1:00 PM-3:00 PM",
        slot4: "3:00 PM-5:00 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
      ScheduleSlotModel(
        id: "68e339ddf9f3db2b39b20de3",
        day: "fri",
        slot1: "9:30 AM-11:30 AM",
        slot2: "11:30 AM-1:30 PM",
        slot3: "2:30 PM-4:30 PM",
        slot4: "4:30 PM-6:30 PM",
        createdAt: DateTime.parse("2025-10-06T03:39:09.444Z"),
        updatedAt: DateTime.parse("2025-10-06T03:53:35.091Z"),
      ),
    ];
  }

  @override
  String toString() {
    return 'ScheduleSlotModel(id: $id, day: $day, slot1: $slot1, slot2: $slot2, slot3: $slot3, slot4: $slot4)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScheduleSlotModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
