import 'package:carded/carded.dart';
import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/models/orders/create_order_model.dart';
import 'package:e_commerce/screens/bottom_navigation_bar.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CreateOrderResponse? orderDetails;

  const OrderConfirmationScreen({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(Icons.check, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Order is Placed Successfully!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              "You can update and review in your orders menu!",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            CardyContainer(
              margin: const EdgeInsets.all(16),
              color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
              spreadRadius: 0,
              blurRadius: 1,
              borderRadius: BorderRadius.circular(8),
              shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(
                      label: "Order ID:",
                      value: orderDetails?.data?.id ?? "N/A",
                    ),
                    _DetailRow(
                      label: "Order Date:",
                      value:
                          formatTime(orderDetails!.data!.orderDate.toString()),
                    ),
                    _DetailRow(
                      label: "Payment Method:",
                      value: orderDetails?.data?.paymentMethod.toUpperCase() ??
                          "N/A",
                    ),
                    _DetailRow(
                      label: "Payment Price:",
                      value: "Rs. ${orderDetails?.data?.orderPrice ?? "N/A"}",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              width: 200,
              height: 50,
              backgroundColor: AppTheme.fMainColor,
              foregroundColor: Colors.white,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarScreen(),
                  ),
                  (route) => false, // This removes all previous routes
                ); 
              },
              text: "Explore More",
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
