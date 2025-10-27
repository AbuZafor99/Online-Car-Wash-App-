import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/controller/payment_controller.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/screens/payment_details.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final PaymentController controller;
  @override
  void initState() {
    controller = Get.find<PaymentController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Complete your order with secure payment',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            Card(
              child: Container(
                height: 374,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'One-time wash by car',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '\$${controller.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Includes 1 wash',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFE8E8E8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPromoInputField(),
                    const SizedBox(height: 20),
                    Divider(color: Color(0xFF428FAD)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '\$${controller.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                                await controller.fetchCreatePayment();
                                if (controller.isPaymentCreated) {
                                  Get.to(() => PaymentDetails());
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 45),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryBlue,
                                  ),
                                ),
                              )
                            : Text(
                                'Pay \$${controller.amount.toStringAsFixed(2)}',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoInputField() {
    return Container(
      height: 40,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFF5BA8C6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF9DCBDD)),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
          Container(
            height: double.maxFinite,
            width: 83,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Apply',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
