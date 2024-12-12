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
  final TextEditingController additionalNotesController =
      TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();

  String? selectedPaymentMethod;
  DateTime? selectedOrderDate;

  bool checkIsServiceDateValid() {
    final DateTime currentDate = DateTime.now();
    final DateTime startDate = widget.service!.startTime!;
    final DateTime endDate = widget.service!.endTime!;

    // Ensure service start and end dates are valid and not expired
    return currentDate.isBefore(endDate) && startDate.isBefore(endDate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime startDate = widget.service!.startTime!;
    final DateTime endDate = widget.service!.endTime!;

    // Set the firstDate to either the start date or current date, whichever is later
    final DateTime firstDate =
        currentDate.isAfter(startDate) ? currentDate : startDate;

    // Ensure initialDate is within the range
    final DateTime initialDate =
        currentDate.isBefore(endDate) ? currentDate : endDate;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: endDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedOrderDate = pickedDate;
        selectedDateController.text = pickedDate
            .toLocal()
            .toString()
            .split(' ')[0]; // Format as YYYY-MM-DD
      });
    }
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
              const SizedBox(height: 10),
              const Text(
                "Select Order Date",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    controller: selectedDateController,
                    label: "Select a date",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Additional Notes (Optional)",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
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
                value: 'cod',
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
                    const SizedBox(width: 20),
                    const Text("Cash on Delivery")
                  ],
                ),
              ),
              RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                value: 'jazzcash',
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
                    const SizedBox(width: 20),
                    const Text("JazzCash")
                  ],
                ),
              ),
              RadioListTile<String>(
                controlAffinity: ListTileControlAffinity.trailing,
                value: 'easypaisa',
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
                    const SizedBox(width: 20),
                    const Text("EasyPaisa")
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!checkIsServiceDateValid()) {
                    showCustomSnackBar(
                      context,
                      "Service availability date is expired!",
                      Colors.red,
                    );
                    return;
                  }

                  if (selectedOrderDate == null) {
                    showCustomSnackBar(
                      context,
                      "Please select a valid order date!",
                      Colors.red,
                    );
                    return;
                  }

                  if (selectedPaymentMethod == null) {
                    showCustomSnackBar(
                      context,
                      "Please select a payment method!",
                      Colors.red,
                    );
                    return;
                  }

                  final order = Order(
                    orderDate: selectedOrderDate.toString(),
                    serviceId: widget.service!.id!,
                    additionalNotes: additionalNotesController.text,
                    paymentMethod: selectedPaymentMethod.toString(),
                    orderPrice: widget.service?.price.toString(),
                  );

                  await orderProvider.bookOrder(order);

                  if (orderProvider.errorMessage != null) {
                    showCustomSnackBar(
                      context,
                      orderProvider.errorMessage!,
                      Colors.red,
                    );
                  } else {
                    showCustomSnackBar(
                      context,
                      "Order booked successfully!",
                      Colors.green,
                    );
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
