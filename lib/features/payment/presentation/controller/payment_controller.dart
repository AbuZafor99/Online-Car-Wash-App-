import 'package:flutter_youssefkleeno/core/base/base_controller.dart';
import 'package:flutter_youssefkleeno/features/payment/domain/repositories/create_payment_repository.dart';
import 'package:flutter_youssefkleeno/features/payment/domain/repositories/payment_repo_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:math' show min;

import '../../data/models/create_payment_model.dart';
import '../../../subscription/data/models/booking_response_model.dart';
import '../../../../core/utils/debug_print.dart';

class PaymentController extends BaseController {
  final CreatePaymentRepository _createPaymentRepository;
  final PaymentRepository? _stripeRepository;

  // Dynamic fields populated from booking response
  final RxString _userId = ''.obs;
  final RxString _bookingId = ''.obs;
  final RxDouble _amount = 0.0.obs;

  // Transaction id from payment response
  final RxString _transactionId = ''.obs;
  String get transactionId => _transactionId.value;

  // Stripe payment intent ID and error tracking
  final RxString paymentIntentId = ''.obs;
  @override
  final RxString errorMessage = ''.obs;

  double get amount => _amount.value;
  bool get isPaymentCreated => _transactionId.value.isNotEmpty;

  /// Clear payment state for new payment
  void clearPaymentState() {
    _transactionId.value = '';
    paymentIntentId.value = '';
    setError('');
    DPrint.log('🧹 Payment state cleared');
  }

  PaymentController(
    this._createPaymentRepository, {
    PaymentRepository? stripeRepository,
  }) : _stripeRepository = stripeRepository;

  /// Set payment data from booking response
  void setFromBooking(BookingResponseModel booking) {
    // Clear any previous payment state
    clearPaymentState();
    
    _userId.value = booking.user;
    _bookingId.value = booking.id;
    _amount.value = booking.price;
    DPrint.log(
      '💰 Payment data set from booking:',
    );
    DPrint.log('   - User ID: ${booking.user}');
    DPrint.log('   - Booking ID: ${booking.id}');
    DPrint.log('   - Amount: \$${booking.price}');
    DPrint.log('   - Internal state check:');
    DPrint.log('     - _userId: ${_userId.value}');
    DPrint.log('     - _bookingId: ${_bookingId.value}');
    DPrint.log('     - _amount: ${_amount.value}');
  }

  Future<void> fetchCreatePayment() async {
    setLoading(true);
    setError('');

    // Validate required fields before making request
    if (_userId.value.isEmpty) {
      setError('User ID is required');
      setLoading(false);
      Get.snackbar(
        'Error',
        'User ID is missing. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_bookingId.value.isEmpty) {
      setError('Booking ID is required');
      setLoading(false);
      Get.snackbar(
        'Error',
        'Booking ID is missing. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_amount.value <= 0) {
      setError('Amount must be greater than 0');
      setLoading(false);
      Get.snackbar(
        'Error',
        'Invalid amount. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Use dynamic values
    final request = CreatePaymentRequest(
      userId: _userId.value,
      bookingId: _bookingId.value,
      amount: _amount.value,
    );

    DPrint.log('📤 Creating payment with request: ${request.toJson()}');
    DPrint.log('🔍 Request details:');
    DPrint.log('   - User ID: ${_userId.value}');
    DPrint.log('   - Booking ID: ${_bookingId.value}');
    DPrint.log('   - Amount: ${_amount.value}');

    final result = await _createPaymentRepository.postPayment(request);
    result.fold(
      (failure) {
        setError(failure.message);
        DPrint.error('❌ Payment failed: ${failure.message}');
        Get.snackbar(
          'Error',
          'Failed to create payment: ${failure.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
      (success) {
        final transactionId = success.data.transactionId;
        _transactionId.value = transactionId;

        DPrint.log('✅ Payment created - Transaction ID: $transactionId');
        DPrint.log(
          '🔍 Transaction ID type check: ${transactionId.startsWith('pi_') ? 'STRIPE CLIENT SECRET' : 'BACKEND TRANSACTION ID'}',
        );

        setLoading(false);
        
        // Navigate to payment details screen
        Get.snackbar(
          'Success',
          'Payment initialized successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  /// Fetch Stripe client secret and process payment using Stripe SDK
  /// Based on working implementation from karlfive project
  Future<bool> processStripePayment() async {
    if (_stripeRepository == null) {
      DPrint.error('❌ Stripe repository not initialized');
      errorMessage.value = 'Stripe payment not available';
      return false;
    }

    if (_transactionId.value.isEmpty) {
      DPrint.error('❌ Transaction ID is empty');
      errorMessage.value = 'Transaction ID required';
      return false;
    }

    // Validate all required fields
    if (_userId.value.isEmpty) {
      DPrint.error('❌ User ID is empty');
      errorMessage.value = 'User ID required for Stripe payment';
      return false;
    }

    if (_bookingId.value.isEmpty) {
      DPrint.error('❌ Booking ID is empty');
      errorMessage.value = 'Booking ID required for Stripe payment';
      return false;
    }

    setLoading(true);
    errorMessage.value = '';

    try {
      DPrint.log('🔄 Fetching Stripe client secret');
      DPrint.log('📋 Transaction ID: ${_transactionId.value}');
      DPrint.log('👤 User ID: ${_userId.value}');
      DPrint.log('🎫 Booking ID: ${_bookingId.value}');
      DPrint.log('💰 Amount: ${_amount.value}');

      // Step 1: Determine client secret. The backend flow expects a backend
      // transaction_id on the first call, and returns a Stripe client_secret.
      // However some flows may already set transactionId to the client_secret
      // (e.g., when resumed). Detect that case and use it directly to avoid
      // sending a client_secret as transaction_id to the backend which caused
      // "All fields are required" errors previously.
      String? clientSecret;

      final txn = _transactionId.value;
      final bool txnLooksLikeSecret =
          txn.contains('_secret_') || txn.startsWith('pi_');

      if (txnLooksLikeSecret) {
        DPrint.log(
          'ℹ️ Transaction id looks like a Stripe secret; using it directly',
        );
        clientSecret = txn;
      } else {
        final result = await _stripeRepository.createPaymentIntent(
          transactionId: txn.isNotEmpty ? txn : null,
          userId: _userId.value,
          ticketId: _bookingId.value,
          amount: _amount.value,
        );

        await result.fold(
          (failure) {
            errorMessage.value = failure.message;
            DPrint.error(
              '❌ Failed to get Stripe client secret: ${failure.message}',
            );
            Get.snackbar(
              'Error',
              'Failed to initialize payment: ${failure.message}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          (success) {
            clientSecret = success.data.clientSecret;
            DPrint.log(
              '✅ Stripe client secret received: ${clientSecret!.substring(0, min(20, clientSecret!.length))}...',
            );
          },
        );
      }

      if (clientSecret == null || clientSecret!.isEmpty) {
        setLoading(false);
        return false;
      }

      // Validate client secret format
      if (!clientSecret!.contains('_secret_') &&
          !clientSecret!.startsWith('pi_')) {
        errorMessage.value = 'Invalid payment client secret';
        DPrint.error('Invalid client_secret provided: $clientSecret');
        setLoading(false);
        return false;
      }

      // Step 2: Initialize & present Stripe PaymentSheet
      DPrint.log('💳 Initializing Stripe payment sheet...');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret!,
          merchantDisplayName: 'YoussefKleeno',
          style: ThemeMode.dark,
        ),
      );

      DPrint.log('📱 Presenting Stripe payment sheet...');
      await Stripe.instance.presentPaymentSheet();

      // Step 3: Extract payment intent ID for server confirmation
      final paymentIntentIdForServer = clientSecret!.contains('_secret_')
          ? clientSecret!.split('_secret_')[0]
          : clientSecret!;

      DPrint.log(
        '✅ Stripe payment successful! Payment Intent: $paymentIntentIdForServer',
      );

      // Step 4: Confirm with backend (optional - don't block on failure)
      final confirmResult = await _stripeRepository.confirmPayment(
        paymentIntentIdForServer,
      );
      confirmResult.fold(
        (fail) {
          // Log failure but don't block navigation
          DPrint.error('Server confirm failed: ${fail.message}');
          DPrint.error('Server confirm failure object: $fail');
        },
        (succ) {
          DPrint.log('✅ Server confirm response: $succ');
        },
      );

      // Proceed regardless of server confirm result
      paymentIntentId.value = paymentIntentIdForServer;
      DPrint.log(
        '🎉 Proceeding to Confirm screen for: $paymentIntentIdForServer',
      );

      Get.snackbar(
        'Success',
        'Payment completed successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on StripeException catch (e) {
      DPrint.error('Stripe Exception: ${e.error.localizedMessage}');
      errorMessage.value = e.error.localizedMessage ?? 'Payment failed';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e, st) {
      DPrint.error('Stripe error: $e\n$st');
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Payment failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      setLoading(false);
    }
  }
}
