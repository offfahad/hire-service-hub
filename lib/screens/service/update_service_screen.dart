import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/models/orders/get_my_orders.dart';
import 'package:e_commerce/models/service/create_service_model.dart';
import 'package:e_commerce/models/service/fetch_signle_service_model.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/bottom_sheet_helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UpdateServiceScreen extends StatefulWidget {
  final FetchSingleService serviceDetail; // Make this field final

  const UpdateServiceScreen({super.key, required this.serviceDetail});

  @override
  State<UpdateServiceScreen> createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends State<UpdateServiceScreen> {
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);

      categoryProvider.fetchCategories();
      final service = widget.serviceDetail.data!.specificService;
      final serivceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      serivceProvider.resetCreateServiceValues();
      serivceProvider.nameController.text = service!.serviceName!;
      serivceProvider.descriptionController.text = service.description!;
      serivceProvider.priceController.text = service.price!.toString();
      serivceProvider.setCategory(
        service.category!.title.toString(),
      );
      _startTime = service.startTime!;
      _endTime = service.endTime!;
      serivceProvider.startTimeController.text =
          DateFormat('h:mm a').format(service.startTime!);
      serivceProvider.endTimeController.text =
          DateFormat('h:mm a').format(service.endTime!);
      serivceProvider.toggleAvailability(service.isAvailable!);
    });
  }

  Future<void> _selectTime(BuildContext context,
      {required TextEditingController controller,
      required ValueChanged<DateTime> onTimeSelected}) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
          now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

      // Format the selected time to 12-hour format with AM/PM
      controller.text = DateFormat('h:mm a').format(dateTime);

      // Notify the parent to update the internal DateTime
      onTimeSelected(dateTime);
    }
  }

  XFile? _newCoverPhoto; // To store the new image selected by the user.

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newCoverPhoto = pickedFile;
      });

      // Now that a new image is selected, call the uploadServiceCoverPhoto API
      final serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      final serviceFilterProvider =
          Provider.of<FilterProvider>(context, listen: false);

      // Assuming serviceProvider has a serviceId that you want to upload the image for
      String serviceId = widget.serviceDetail.data!.specificService!.id!;

      try {
        await serviceProvider.uploadServiceCoverPhoto(
          _newCoverPhoto!.path, // Pass the image path
          serviceId, // Pass the serviceId
        );

        if (serviceProvider.errorMessage != null) {
          showCustomSnackBar(
              context, serviceProvider.errorMessage!, Colors.red);
        } else {
          serviceProvider.fetchSingleServiceDetail(
              widget.serviceDetail.data!.specificService!.id!);
          serviceProvider.fetchFilterServices();
          serviceProvider.clearFilters;
          serviceFilterProvider.resetFilter("Category");
          serviceFilterProvider.resetCategoryID();

          showCustomSnackBar(
              context, "Cover photo updated successfully!", Colors.green);
        }
      } catch (e) {
        showCustomSnackBar(
            context, "An error occurred: ${e.toString()}", Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Service',
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
                  Stack(
                    children: [
                      InkWell(
                        onTap: _selectImage, // Open Gallery on tap
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppTheme.fdarkBlue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: _newCoverPhoto == null
                              ? (widget.serviceDetail.data?.specificService
                                          ?.coverPhoto ==
                                      null
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      ),
                                    )
                                  : Image.network(
                                      widget.serviceDetail.data?.specificService
                                          ?.coverPhoto,
                                      fit: BoxFit.cover,
                                    ))
                              : Image.file(
                                  File(_newCoverPhoto!.path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      // If there is a cover photo, show the Edit button
                      if (widget.serviceDetail.data?.specificService
                              ?.coverPhoto !=
                          null)
                        Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: AppTheme.fMainColor,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: _selectImage,
                              ),
                            )),
                    ],
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
                        border: Border.all(width: 0.5),
                        color: isDarkMode
                            ? ThemeData().scaffoldBackgroundColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
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
                    height: 16,
                  ),
                  // Name Field
                  CustomTextFormField(
                    controller: serviceProvider.nameController,
                    label: "Enter service name",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Description Field
                  CustomTextFormField(
                    controller: serviceProvider.descriptionController,
                    label: "Enter service description",
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Price Field
                  CustomTextFormField(
                    controller: serviceProvider.priceController,
                    label: "Enter service price (Rs)",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Start and End Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => _selectTime(
                                context,
                                controller: serviceProvider.startTimeController,
                                onTimeSelected: (selectedTime) {
                                  setState(() {
                                    _startTime =
                                        selectedTime; // Store the time internally
                                  });
                                },
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
                              onTap: () => _selectTime(
                                context,
                                controller: serviceProvider.endTimeController,
                                onTimeSelected: (selectedTime) {
                                  setState(() {
                                    _startTime =
                                        selectedTime; // Store the time internally
                                  });
                                },
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
                  const SizedBox(
                    height: 16,
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
                  const SizedBox(
                    height: 16,
                  ),
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
                            price: int.tryParse(serviceProvider
                                .priceController.text
                                .trim()
                                .toString())!,
                            startTime: _startTime.toString(),
                            endTime: _endTime.toString(),
                            categoryId: categoryProvider.getCategoryIdByName(
                                serviceProvider.selectedCategory),
                            isAvailable: serviceProvider.isAvailable,
                          );
                          serviceProvider.updateService(
                              widget.serviceDetail.data!.specificService!.id!,
                              serviceData);
                          serviceProvider.fetchSingleServiceDetail(
                              widget.serviceDetail.data!.specificService!.id!);
                          showCustomSnackBar(context,
                              "Services Updated Successfully!", Colors.green);
                          Navigator.pop(context);
                        } else {
                          showCustomSnackBar(
                              context,
                              'Please fill all fields and add a cover photo.',
                              Colors.red);
                        }
                      },
                      text: "Update Service",
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
    return serviceProvider.nameController.text.trim().isNotEmpty &&
        serviceProvider.descriptionController.text.trim().isNotEmpty &&
        serviceProvider.priceController.text.trim().isNotEmpty &&
        serviceProvider.startTimeController.text.trim().isNotEmpty &&
        serviceProvider.endTimeController.text.trim().isNotEmpty &&
        serviceProvider.selectedCategory.isNotEmpty;
  }
}
