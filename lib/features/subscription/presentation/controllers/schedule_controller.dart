import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutx_core/flutx_core.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/schedule_slot_model.dart';
import '../../domain/repositories/schedule_repository.dart';

class WashTypeOption {
  final String id;
  final String name;
  final String description;
  final bool isDry;
  final String tag;

  WashTypeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.isDry,
    required this.tag,
  });

  factory WashTypeOption.fromMap(Map<String, dynamic> map) {
    final id = (map['_id'] ?? map['id'] ?? '').toString();
    final name = (map['serviceName'] ?? map['name'] ?? map['title'] ?? '')
        .toString();
    final description =
        (map['serviceDescription'] ??
                map['description'] ??
                map['details'] ??
                '')
            .toString();
    final isDry =
        (map['isDry'] != null &&
            (map['isDry'] == true || map['isDry'].toString() == '1')) ||
        name.toLowerCase().contains('dry') ||
        (map['washType'] ?? '').toString().toLowerCase().contains('dry');
    final tag = (map['tag'] ?? '').toString();

    return WashTypeOption(
      id: id.isNotEmpty ? id : name, // Use ID if available, otherwise use name
      name: name,
      description: description,
      isDry: isDry,
      tag: tag,
    );
  }
}

class ScheduleController extends BaseController {
  final ScheduleRepository _repository;

  ScheduleController(this._repository);

  // Private observable states
  final RxList<ScheduleSlotModel> _allScheduleSlots = <ScheduleSlotModel>[].obs;
  final RxList<WashTypeOption> _washTypes = <WashTypeOption>[].obs;

  // Public getters
  List<ScheduleSlotModel> get allScheduleSlots => _allScheduleSlots.toList();
  List<WashTypeOption> get washTypes => _washTypes.toList();

  // Selected dates and their details
  final RxSet<int> selectedDates = <int>{}.obs;
  final RxMap<int, SelectedDateInfo> selectedDateDetails =
      <int, SelectedDateInfo>{}.obs;

  // Current month calendar data
  final RxList<int?> calendarDays = <int?>[].obs;
  final RxString currentMonth = ''.obs;
  final RxInt currentYear = DateTime.now().year.obs;

  // Subscription type management
  final RxString _subscriptionType = 'Monthly Subscription'.obs;
  String get subscriptionType => _subscriptionType.value;
  bool get isOneTimeWash => _subscriptionType.value == 'One-time Wash';
  int get maxDateSelection => isOneTimeWash ? 1 : 4;

  @override
  void onInit() {
    super.onInit();
    _initializeCalendar();
    loadWashTypes();
    // Note: We'll load schedule slots per date when user taps on a date
    // loadScheduleSlots(); // This can be removed as we fetch slots per selected date
  }

  /// Set subscription type and clear previous selections
  void setSubscriptionType(String type) {
    // Normalize the incoming subscription type string to handle variants
    // like 'one-time', 'One time', 'onetime', etc.
    final input = type.trim();
    final lower = input.toLowerCase();
    final bool detectedOneTime =
        (lower.contains('one') && lower.contains('time')) ||
        lower.contains('onetime') ||
        lower.contains('one-time');
    final String canonical = detectedOneTime
        ? 'One-time Wash'
        : 'Monthly Subscription';

    DPrint.log(
      '🎯 Setting subscription type from: ${_subscriptionType.value} to: $input (normalized: $canonical)',
    );
    // Ensure we have a console-visible log in addition to DPrint
    print(
      'ScheduleController: setSubscriptionType called -> input: "$input" normalized: "$canonical"',
    );

    if (_subscriptionType.value != canonical) {
      _subscriptionType.value = canonical;
      // Clear previous selections when subscription type changes
      clearAllSelections();
      // Reload wash types for the new subscription type
      DPrint.log('🔄 Subscription type changed. Reloading wash types...');
      loadWashTypes();
      DPrint.log(
        '✅ Subscription type set to: $canonical (Max dates: $maxDateSelection), isOneTimeWash: $isOneTimeWash',
      );
    } else {
      // Even if type hasn't changed, reload wash types to ensure freshness
      // This is critical when controller persists across navigation (fenix:true)
      DPrint.log(
        'ℹ️ Subscription type unchanged ($canonical), but reloading wash types to ensure correct data',
      );
      loadWashTypes();
    }
  }

  void _initializeCalendar() {
    final now = DateTime.now();
    currentMonth.value = _getMonthName(now.month);
    currentYear.value = now.year;
    _generateCalendarDays();
  }

  void _generateCalendarDays() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // Sunday = 0

    List<int?> days = [];

    // Add empty spaces for days before the first day of the month
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }

    // Add all days of the month
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(i);
    }

    calendarDays.value = days;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Future<void> loadScheduleSlots() async {
    setLoading(true);
    setError('');

    final result = await _repository.getScheduleSlots();

    result.fold(
      (failure) {
        setError(failure.message);
        DPrint.log('Get schedule slots failed: ${failure.message}');
        Get.snackbar('Error', failure.message);
        setLoading(false);
      },
      (success) {
        _allScheduleSlots.value = success.data;
        DPrint.log(
          'Get schedule slots success: ${success.data.length} slots loaded',
        );
        setLoading(false);
      },
    );
  }

  Future<void> loadWashTypes() async {
    try {
      final apiClient = Get.find<ApiClient>();
      DPrint.log(
        '🔄 Loading wash types for subscription type: $subscriptionType',
      );

      final result = await apiClient.get(
        ApiConstants.service.getServices,
        queryParameters: {'washType': subscriptionType, 'limit': '30'},
        fromJsonT: (j) => j,
      );

      result.fold(
        (failure) {
          DPrint.log('❌ Get wash types failed: ${failure.message}');
          _washTypes.value = _getDefaultWashTypes();
        },
        (success) {
          final data = success.data;
          List<dynamic> raw = [];

          // Handle different API response formats (same as wash_type_screen.dart)
          if (data is List) {
            raw = data.cast<dynamic>();
          } else if (data is Map) {
            if (data['services'] != null && data['services'] is List) {
              raw = (data['services'] as List).cast<dynamic>();
            } else if (data['service'] != null && data['service'] is List) {
              raw = (data['service'] as List).cast<dynamic>();
            }
          }

          if (raw.isEmpty) {
            DPrint.log('⚠️ No services found in API response, using defaults');
            _washTypes.value = _getDefaultWashTypes();
            return;
          }

          _washTypes.value = raw
              .map(
                (e) =>
                    WashTypeOption.fromMap(Map<String, dynamic>.from(e as Map)),
              )
              .toList();

          DPrint.log(
            '✅ Get wash types success: ${_washTypes.length} types loaded for $subscriptionType',
          );
          DPrint.log(
            '📋 Wash types: ${_washTypes.map((w) => w.name).toList()}',
          );
        },
      );
    } catch (e) {
      DPrint.log('💥 Error loading wash types: $e');
      _washTypes.value = _getDefaultWashTypes();
    }
  }

  List<WashTypeOption> _getDefaultWashTypes() {
    DPrint.log(
      '🎯 Getting default wash types for: $subscriptionType (isOneTimeWash: $isOneTimeWash)',
    );

    if (isOneTimeWash) {
      return [
        WashTypeOption(
          id: 'express_wash_onetime',
          name: 'Express Wash',
          description: 'Quick and efficient one-time wash',
          isDry: false,
          tag: 'Express',
        ),
        WashTypeOption(
          id: 'premium_wash_onetime',
          name: 'Premium Wash',
          description: 'Complete one-time wash service',
          isDry: false,
          tag: 'Premium',
        ),
      ];
    } else {
      return [
        WashTypeOption(
          id: 'dry_wash_monthly',
          name: 'Dry Wash',
          description: 'Eco-friendly wash without using water',
          isDry: true,
          tag: 'Eco-friendly',
        ),
        WashTypeOption(
          id: 'water_wash_monthly',
          name: 'Water Wash',
          description: 'Traditional water wash',
          isDry: false,
          tag: 'Standard',
        ),
      ];
    }
  }

  Future<void> onDateTap(int date) async {
    DPrint.log('📅 Date tapped: $date');
    DPrint.log(
      '� Subscription type: $subscriptionType, isOneTimeWash: $isOneTimeWash, maxDateSelection: $maxDateSelection',
    );
    DPrint.log('�📋 Selected dates before: ${selectedDates.toList()}');
    // console-visible debug
    print(
      'ScheduleController.onDateTap -> date: $date, subscription: $subscriptionType, selectedBefore: ${selectedDates.toList()}, max: $maxDateSelection',
    );

    // Check if the date is in the past
    if (isDateInPast(date)) {
      Get.snackbar(
        'Invalid Date',
        'Cannot select past dates. Please choose a date from today onwards.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        icon: Icon(Icons.error_outline, color: Colors.red.shade600),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      DPrint.log('❌ Cannot select past date: $date');
      return;
    }

    if (selectedDates.contains(date)) {
      // Remove date if already selected
      selectedDates.remove(date);
      selectedDateDetails.remove(date);
      DPrint.log(
        '🗑️ Date $date removed. Selected dates now: ${selectedDates.toList()}',
      );
      print(
        'ScheduleController.onDateTap -> removed $date, selectedNow: ${selectedDates.toList()}',
      );
    } else if (selectedDates.length < maxDateSelection) {
      // Add date if less than max are selected
      selectedDates.add(date);
      DPrint.log(
        '✅ Date $date added. Selected dates now: ${selectedDates.toList()}',
      );
      print(
        'ScheduleController.onDateTap -> added $date, selectedNow: ${selectedDates.toList()}',
      );

      // Fetch slots for this date
      await _fetchSlotsForDate(date);
    } else {
      final maxText = isOneTimeWash ? '1 date' : '4 dates';
      Get.snackbar(
        'Limit Reached',
        'You can only select up to $maxText',
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
        icon: Icon(Icons.info_outline, color: Colors.orange.shade600),
        duration: const Duration(seconds: 3),
      );
      DPrint.log(
        '⚠️ Limit reached. Cannot add date $date (selected: ${selectedDates.length}, max: $maxDateSelection)',
      );
      print(
        'ScheduleController.onDateTap -> limit reached on date $date, selected: ${selectedDates.length}, max: $maxDateSelection',
      );
    }
  }

  Future<void> _fetchSlotsForDate(int date) async {
    setLoading(true);
    clearError();

    final dateTime = DateTime(currentYear.value, DateTime.now().month, date);
    final formattedDate =
        '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';

    DPrint.log(
      '🗓️ Fetching slots for date: $dateTime (formatted: $formattedDate)',
    );
    DPrint.log(
      '🌐 API Endpoint: ${ApiConstants.schedule.getSlotsByDate}?date=$formattedDate',
    );

    final result = await _repository.getSlotsByDate(dateTime);

    result.fold(
      (failure) {
        setError('Failed to fetch slots: ${failure.message}');
        DPrint.log('❌ Get slots for date failed: ${failure.message}');
        DPrint.log('🔍 Status Code: ${failure.statusCode}');

        // Remove the date if failed to fetch slots
        selectedDates.remove(date);
        Get.snackbar(
          'API Error',
          'Could not load time slots for selected date.\n${failure.message}',
          duration: const Duration(seconds: 4),
        );
        setLoading(false);
      },
      (success) {
        DPrint.log('✅ Get slots for date success: date $date');
        DPrint.log('📊 Slot data: ${success.data}');

        // Validate the slot data
        if (success.data.allSlots.isEmpty ||
            success.data.allSlots.every((slot) => slot.isEmpty)) {
          DPrint.log('⚠️ Warning: No valid time slots found for date $date');
          // Still create the entry but show a warning
          Get.snackbar(
            'Limited Availability',
            'No time slots available for this date',
            duration: const Duration(seconds: 3),
          );
        }

        selectedDateDetails[date] = SelectedDateInfo(
          date: date,
          scheduleSlot: success.data,
          selectedTimeSlot: null,
          washType: '',
        );
        setLoading(false);
      },
    );
  }

  void onTimeSlotSelected(int date, String timeSlot) {
    if (selectedDateDetails.containsKey(date)) {
      final currentInfo = selectedDateDetails[date]!;
      selectedDateDetails[date] = currentInfo.copyWith(
        selectedTimeSlot: timeSlot,
      );
    }
  }

  void onWashTypeChanged(int date, String washType) {
    if (selectedDateDetails.containsKey(date)) {
      final currentInfo = selectedDateDetails[date]!;
      // Toggle behavior: if the same washType is tapped again, unset it (empty string)
      final newWashType = currentInfo.washType == washType ? '' : washType;
      selectedDateDetails[date] = currentInfo.copyWith(washType: newWashType);
    }
  }

  bool isWashTypeSelected(int date, String washType) {
    if (selectedDateDetails.containsKey(date)) {
      return selectedDateDetails[date]!.washType == washType;
    }
    return false;
  }

  String? getSelectedWashTypeName(int date) {
    final selectedId = getSelectedWashType(date);
    if (selectedId == null) return null;

    final washType = _washTypes.firstWhereOrNull((wt) => wt.id == selectedId);
    return washType?.name;
  }

  String getFormattedDate(int date) {
    final now = DateTime.now();
    return '${date.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  bool isDateSelected(int date) => selectedDates.contains(date);

  /// Check if a date is in the past (before today)
  bool isDateInPast(int date) {
    final now = DateTime.now();
    final selectedDate = DateTime(currentYear.value, now.month, date);
    final today = DateTime(now.year, now.month, now.day);
    return selectedDate.isBefore(today);
  }

  /// Check if a date is valid for selection
  bool canSelectDate(int date) {
    return !isDateInPast(date);
  }

  List<String> getTimeSlotsForDate(int date) {
    if (selectedDateDetails.containsKey(date)) {
      return selectedDateDetails[date]!.scheduleSlot.allSlots;
    }
    return [];
  }

  bool isTimeSlotSelected(int date, String timeSlot) {
    if (selectedDateDetails.containsKey(date)) {
      return selectedDateDetails[date]!.selectedTimeSlot == timeSlot;
    }
    return false;
  }

  String? getSelectedWashType(int date) {
    if (selectedDateDetails.containsKey(date)) {
      final wt = selectedDateDetails[date]!.washType;
      return wt.isEmpty ? null : wt;
    }
    return null;
  }

  // Validation methods
  bool get canProceed {
    if (selectedDates.length != maxDateSelection) return false;

    for (final date in selectedDates) {
      final info = selectedDateDetails[date];
      if (info == null ||
          info.selectedTimeSlot == null ||
          info.washType.isEmpty) {
        return false;
      }
    }
    return true;
  }

  List<int> get selectedDatesList => selectedDates.toList()..sort();

  void clearAllSelections() {
    selectedDates.clear();
    selectedDateDetails.clear();
  }

  // Get summary of all selections
  Map<String, dynamic> getSelectionSummary() {
    final summary = <String, dynamic>{};

    for (final date in selectedDatesList) {
      final info = selectedDateDetails[date];
      if (info != null) {
        final washTypeName = getSelectedWashTypeName(date) ?? info.washType;
        summary[getFormattedDate(date)] = {
          'timeSlot': info.selectedTimeSlot,
          'washType': washTypeName,
          'washTypeId': info.washType,
          'dayOfWeek': info.scheduleSlot.day,
        };
      }
    }

    return summary;
  }
}

class SelectedDateInfo {
  final int date;
  final ScheduleSlotModel scheduleSlot;
  final String? selectedTimeSlot;
  final String washType;

  SelectedDateInfo({
    required this.date,
    required this.scheduleSlot,
    required this.selectedTimeSlot,
    required this.washType,
  });

  SelectedDateInfo copyWith({
    int? date,
    ScheduleSlotModel? scheduleSlot,
    String? selectedTimeSlot,
    String? washType,
  }) {
    return SelectedDateInfo(
      date: date ?? this.date,
      scheduleSlot: scheduleSlot ?? this.scheduleSlot,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      washType: washType ?? this.washType,
    );
  }

  @override
  String toString() {
    return 'SelectedDateInfo(date: $date, selectedTimeSlot: $selectedTimeSlot, washType: $washType)';
  }
}
