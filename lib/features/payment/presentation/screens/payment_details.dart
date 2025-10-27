import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/controller/payment_controller.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/screens/confirmed.dart';
import 'package:get/get.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  late final PaymentController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PaymentController>();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 17),
              const Text(
                'Complete your booking by making a payment',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 29),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE1E1E2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${controller.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFE8F1F5),
                        border: Border.all(color: const Color(0xFF98C7DA)),
                      ),
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/lock.png',
                            height: 14,
                            width: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              controller.isLoading.value
                                  ? 'Initializing secure payment...'
                                  : 'Your payment information is secure and encrypted',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primaryBlue,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isLoading.value) ...[
                      const SizedBox(height: 20),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Payment Information Card
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE1E1E2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Transaction ID: ${controller.transactionId}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: Payment initialized',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Proceed to Stripe Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          // Process Stripe payment
                          final paymentSuccess = await controller.processStripePayment();
                          if (paymentSuccess && mounted) {
                            Get.off(() => const Confirmed());
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Proceed with Stripe Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}
