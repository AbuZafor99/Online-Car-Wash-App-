class PaymentRequest {
  final double amount;
  final String currency;
  final String? transactionId;
  final String? userId;
  final String? bookingId;

  PaymentRequest({
    required this.amount,
    required this.currency,
    this.transactionId,
    this.userId,
    this.bookingId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'amount': amount, 'currency': currency};

    // Always include user_id and booking_id if available
    if (userId?.isNotEmpty == true) {
      data['user_id'] = userId;
    }
    if (bookingId?.isNotEmpty == true) {
      data['booking_id'] = bookingId;
    }

    // Add transaction_id only if provided (for second call to backend)
    if (transactionId?.isNotEmpty == true) {
      data['transaction_id'] = transactionId;
    }

    return data;
  }
}
