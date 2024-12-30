import 'dart:convert';

import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderUpdateScreen extends StatefulWidget {
  final Datum order;
  const OrderUpdateScreen({super.key, required this.order});

  @override
  State<OrderUpdateScreen> createState() => _OrderUpdateScreenState();
}

class _OrderUpdateScreenState extends State<OrderUpdateScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    additionalNotesController.text = widget.order.additionalNotes.toString();
    selectedDateController.text = formatDate(widget.order.orderDate.toString()); 
    selectedOrderDate = widget.order.orderDate;
  }

  final TextEditingController additionalNotesController =
      TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  DateTime? selectedOrderDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          currentDate.add(const Duration(days: 1)), // Start with tomorrow
      firstDate: currentDate.add(const Duration(days: 1)), // Exclude today
      lastDate: DateTime(2100), // Arbitrary future date
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Order',
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
                  "Rs${widget.order.service.price}",
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 40,
                  width: 150,
                  child: Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.fMainColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: orderProvider.isLoading
                            ? null // Disable button while loading
                            : () async {
                                // Input validation checks
                                if (selectedOrderDate == null) {
                                  showCustomSnackBar(
                                    context,
                                    "Please select a valid order date!",
                                    Colors.red,
                                  );
                                  return;
                                }

                                // Perform API call
                                final response =
                                    await orderProvider.updateOrder(
                                  orderId: widget
                                      .order.id, // Use appropriate `orderId`
                                  orderDate: selectedOrderDate
                                      .toString(), // Replace with selected date
                                  additionalNotes: additionalNotesController
                                      .text, // Replace with user input
                                );

                                if (response != null) {
                                  if (response.statusCode == 200) {
                                    // On success
                                    final responseData =
                                        jsonDecode(response.body);
                                    showCustomSnackBar(
                                      context,
                                      responseData['message'] ??
                                          "Order updated successfully!",
                                      Colors.green,
                                    );
                                    orderProvider.fetchMyOrders();
                                    // Navigate back to previous screen
                                    Navigator.pop(
                                        context); // Close dialog/screen
                                    Navigator.pop(context);
                                  } else {
                                    // On failure
                                    final responseData =
                                        jsonDecode(response.body);
                                    showCustomSnackBar(
                                      context,
                                      responseData['message'] ??
                                          "Failed to update order",
                                      Colors.red,
                                    );
                                  }
                                } else {
                                  // Handle unexpected errors
                                  showCustomSnackBar(
                                    context,
                                    orderProvider.errorMessage ??
                                        "Something went wrong!",
                                    Colors.red,
                                  );
                                }
                              },
                        child: orderProvider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Update Order'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
