class CreatePaymentRequest {
  final String userId;
  final String bookingId;
  final double amount;

  CreatePaymentRequest({
    required this.userId,
    required this.bookingId,
    required this.amount,
  });

  /// Convert to JSON using camelCase keys which the backend expects.
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'bookingId': bookingId, 'amount': amount};
  }

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) {
    return CreatePaymentRequest(
      userId: (json['user_id'] ?? json['userId'] ?? '') as String,
      bookingId: (json['booking_id'] ?? json['bookingId'] ?? '') as String,
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse((json['amount'] ?? '0').toString()) ?? 0.0,
    );
  }
}

class CreatePaymentResponse {
  final String transactionId;

  CreatePaymentResponse({required this.transactionId});

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    // Log the raw response for debugging
    print('🔍 Raw API Response: $json');
    
    // Accept either direct transactionId or nested in data
    String transactionId = '';
    
    if (json.containsKey('transactionId')) {
      transactionId = json['transactionId']?.toString() ?? '';
    } else if (json.containsKey('data') && json['data'] is Map) {
      final data = json['data'] as Map<String, dynamic>;
      transactionId = data['transactionId']?.toString() ?? '';
    } else {
      // Fallback: check for other possible keys
      transactionId = json['transaction_id']?.toString() ?? 
                     json['id']?.toString() ?? '';
    }
    
    print('🔍 Parsed transactionId: $transactionId');
    
    return CreatePaymentResponse(transactionId: transactionId);
  }
}
