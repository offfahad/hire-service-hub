import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/models/service/create_service_model.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/bottom_sheet_helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      categoryProvider.fetchCategories();
      Provider.of<ServiceProvider>(context, listen: false)
          .resetCreateServiceValues();
    });
  }

  Future<void> _selectDate(BuildContext context,
      {required TextEditingController controller}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest date allowed
      lastDate: DateTime(2100), // Latest date allowed
    );
    if (selectedDate != null) {
      // Update the controller with the selected date
      controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    final ImagePicker picker = ImagePicker();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a new Service',
          style: TextStyle(fontSize: 18),
        ),
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Consumer2<ServiceProvider, CategoryProvider>(
            builder: (context, serviceProvider, categoryProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Photo
                  InkWell(
                    onTap: () async {
                      final pickedPhoto =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedPhoto != null) {
                        serviceProvider.setCoverPhoto(pickedPhoto);
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? AppTheme.fdarkBlue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: serviceProvider.coverPhoto == null
                          ? const Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconlyLight.image,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Select a photo'),
                              ],
                            ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(serviceProvider.coverPhoto!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () => openFilterBottomSheet(
                        title: "Select a Category",
                        context: context,
                        options: categoryProvider.categoryNames,
                        onSelect: (String? value) {
                          serviceProvider.setCategory(value!);
                          Navigator.pop(context);
                        },
                        onReset: () {
                          serviceProvider.setCategory('');
                          Navigator.pop(context);
                        }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? AppTheme.fdarkBlue : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        serviceProvider.selectedCategory.isEmpty
                            ? 'Select a Category'
                            : serviceProvider.selectedCategory,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : serviceProvider.selectedCategory != "" &&
                                      serviceProvider
                                          .selectedCategory.isNotEmpty
                                  ? Colors.black
                                  : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Name Field
                  CustomTextFormField(
                    controller: serviceProvider.nameController,
                    label: "Enter service name",
                  ),

                  // Description Field
                  CustomTextFormField(
                    controller: serviceProvider.descriptionController,
                    label: "Enter service description",
                    maxLines: 2,
                  ),

                  // Price Field
                  CustomTextFormField(
                    controller: serviceProvider.priceController,
                    label: "Enter service price (Rs)",
                    keyboardType: TextInputType.number,
                  ),

                  // Start and End Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => _selectDate(
                                context,
                                controller: serviceProvider.startTimeController,
                              ),
                              child: CustomTextFormField(
                                controller: serviceProvider.startTimeController,
                                label: "Start Time",
                                isEditable: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => _selectDate(
                                context,
                                controller: serviceProvider.endTimeController,
                              ),
                              child: CustomTextFormField(
                                controller: serviceProvider.endTimeController,
                                label: "End Time",
                                isEditable: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Availability Checkbox
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: serviceProvider.isAvailable,
                          onChanged: (value) {
                            serviceProvider.toggleAvailability(value!);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Available'),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomGradientButton(
                      onPressed: () {
                        if (_validateInputs(serviceProvider)) {
                          final serviceData = CreateService(
                            serviceName:
                                serviceProvider.nameController.text.trim(),
                            description: serviceProvider
                                .descriptionController.text
                                .trim(),
                            price: double.tryParse(
                                    serviceProvider.priceController.text.trim())
                                .toString(),
                            startTime: DateTime.parse(
                                serviceProvider.startTimeController.text),
                            endTime: DateTime.parse(
                                serviceProvider.endTimeController.text.trim()),
                            categoryId: categoryProvider.getCategoryIdByName(
                                serviceProvider.selectedCategory),
                            isAvailable: serviceProvider.isAvailable,
                          );
                          serviceProvider.createServiceWithCoverPhoto(
                            serviceData,
                            serviceProvider
                                .coverPhoto!.path, // Cover photo path
                          );
                          showCustomSnackBar(context,
                              "Services Created Successfully!", Colors.green);
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(
                              context,
                              'Please fill all fields and add a cover photo.',
                              Colors.red);
                        }
                      },
                      text: "Save Service",
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Validation Method
  bool _validateInputs(ServiceProvider serviceProvider) {
    return serviceProvider.coverPhoto != null &&
        serviceProvider.nameController.text.trim().isNotEmpty &&
        serviceProvider.descriptionController.text.trim().isNotEmpty &&
        serviceProvider.priceController.text.trim().isNotEmpty &&
        serviceProvider.startTimeController.text.trim().isNotEmpty &&
        serviceProvider.endTimeController.text.trim().isNotEmpty &&
        serviceProvider.selectedCategory.isNotEmpty;
  }
}
