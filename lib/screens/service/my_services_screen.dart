// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/service/widgets/service_card_widget.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchMyServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("My Services"),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: AppTheme.fMainColor,
              ),
            );
          } else if ((provider.errorMessage ?? "").isNotEmpty) {
            return Center(
              child: Text('Error: ${provider.errorMessage}'),
            );
          } else if (provider.myServices.isEmpty) {
            return const Center(
              child: Text('No services available'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.myServices.length,
              itemBuilder: (context, index) {
                final service = provider.myServices[index];
                return ServiceCard(service: service);
              },
            );
          }
        },
      ),
    );
  }
}
