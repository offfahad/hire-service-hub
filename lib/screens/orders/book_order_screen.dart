import 'package:e_commerce/models/orders/order_model.dart';
import 'package:e_commerce/providers/orders/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookOrderScreen extends StatelessWidget {
  final TextEditingController orderDateController = TextEditingController();
  final TextEditingController serviceIdController = TextEditingController();
  final TextEditingController additionalNotesController =
      TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: orderDateController,
              decoration: const InputDecoration(labelText: 'Order Date'),
            ),
            TextField(
              controller: serviceIdController,
              decoration: const InputDecoration(labelText: 'Service ID'),
            ),
            TextField(
              controller: additionalNotesController,
              decoration: const InputDecoration(labelText: 'Additional Notes'),
            ),
            TextField(
              controller: paymentMethodController,
              decoration: const InputDecoration(labelText: 'Payment Method'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final order = Order(
                  orderDate: orderDateController.text,
                  serviceId: serviceIdController.text,
                  additionalNotes: additionalNotesController.text,
                  paymentMethod: paymentMethodController.text,
                  orderPrice: "100", // Example price
                  customerAddress: "123 Street Name",
                );

                await orderProvider.bookOrder(order);

                if (orderProvider.errorMessage != null) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(orderProvider.errorMessage!)),
                  );
                } else {
                  // Success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order booked successfully!")),
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
    );
  }
}
