import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookOrderScreen extends StatefulWidget {
  final SpecificService? service;

  const BookOrderScreen({super.key, required this.service});

  @override
  State<BookOrderScreen> createState() => _BookOrderScreenState();
}

class _BookOrderScreenState extends State<BookOrderScreen> {
  final TextEditingController serviceIdController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();

  String? selectedPaymentMethod; // Variable to store selected payment method

  checkIsServiceDateValid(DateTime day) {
    DateTime startDate = widget.service!.startTime!;
    DateTime endDate = widget.service!.endTime!;
    return day.isAfter(startDate) && day.isBefore(endDate);
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Order',
        ),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Service Details",
                style: TextStyle(fontSize: 18),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Total Price",
                ),
                subtitle: const Text(
                  "Inc. taxes",
                ),
                trailing: Text(
                  "Rs${widget.service?.price ?? 'N/A'}",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Additional Notes",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextFormField(
                controller: additionalNotesController,
                label: "Any Special Instructions Here...",
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                value: 'COD',
                contentPadding: EdgeInsets.zero,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
                title: Row(
                  children: [
                    Image.asset(
                      'assets/logos/cod.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("Cash on Delivery")
                  ],
                ),
              ),
              RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                value: 'JazzCash',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
                title: Row(
                  children: [
                    Image.asset(
                      'assets/logos/jazzcash_logo.png',
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("JazzCash")
                  ],
                ),
              ),
              RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                value: 'EasyPaisa',
                contentPadding: EdgeInsets.zero,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
                title: Row(
                  children: [
                    Image.asset('assets/logos/easypaisa_logo.png',
                        width: 30, height: 30),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("EasyPaisa")
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime currentDate = DateTime.now();
                  if (checkIsServiceDateValid(currentDate)) {
                    final order = Order(
                      orderDate: currentDate.toString(),
                      serviceId: serviceIdController.text,
                      additionalNotes: additionalNotesController.text,
                      paymentMethod: selectedPaymentMethod.toString(),
                      orderPrice:
                          widget.service?.price.toString(), // Example price
                    );
          
                    await orderProvider.bookOrder(order);
          
                    if (orderProvider.errorMessage != null) {
                      // Handle error
                      showCustomSnackBar(
                          context, orderProvider.errorMessage!, Colors.red);
                    } else {
                      // Success
                      showCustomSnackBar(
                          context, "Order booked successfully!", Colors.green);
                    }
                  } else {
                    showCustomSnackBar(context,
                        "Service availability date is expired!", Colors.red);
                  }
                },
                child: orderProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Book Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
