import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/models/pc_build.dart';
import 'package:image_picker/image_picker.dart';

class AddBuildScreen extends StatefulWidget {
  final PcBuild? buildToEdit;
  final String? documentId;
  const AddBuildScreen({super.key, this.buildToEdit, this.documentId});

  @override
  State<AddBuildScreen> createState() => _AddBuildScreenState();
}

class _AddBuildScreenState extends State<AddBuildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  File? _selectedImage;
  String? _existingImageUrl;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.buildToEdit != null) {
      _titleController.text = widget.buildToEdit!.title;
      _priceController.text = widget.buildToEdit!.price.toString();
      _descriptionController.text = widget.buildToEdit!.description;
      if (widget.buildToEdit!.imageUrl.isNotEmpty) {
        _existingImageUrl = widget.buildToEdit!.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 50,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _existingImageUrl = null;
        });
      }
    } catch (e) {
      print('Error picking image: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _submitBuild() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = '';
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        final base64Image = base64Encode(bytes);
        imageUrl = 'data:image/jpeg;base64,$base64Image';
      } else if (_existingImageUrl != null) {
        imageUrl = _existingImageUrl!;
      }

      final double price = double.parse(_priceController.text.replaceAll('\$', '').trim());
      final build = PcBuild(
        title: _titleController.text.trim(),
        price: price,
        rating: widget.buildToEdit?.rating ?? "★ 0.0 (0 reviews)",
        imageUrl: imageUrl,
        description: _descriptionController.text.trim(),
      );

      if (widget.buildToEdit != null && widget.documentId != null) {
        // Edit mode: update existing document
        await FirebaseFirestore.instance
            .collection('community')
            .doc(widget.documentId)
            .update(build.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Build updated successfully!')),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Add mode: add new document
        await FirebaseFirestore.instance
            .collection('community')
            .add(build.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Build added successfully!')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      print('Error saving build: $e'); // Debug print
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a price';
    }
    
    // Remove $ sign if present
    final cleanValue = value.replaceAll('\$', '').trim();
    
    try {
      final price = double.parse(cleanValue);
      if (price < 0) {
        return 'Price cannot be negative';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          labelStyle: TextStyle(color: Colors.black),
          floatingLabelStyle: TextStyle(color: Colors.black),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.bodyBackgroundColor,
          title: const Text('Add New Build', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        backgroundColor: AppColors.bodyBackgroundColor,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate, size: 50),
                                      SizedBox(height: 8),
                                      Text('Tap to add image (optional)'),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Build Title',
                          hintText: 'e.g., High-End Gaming Build',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'e.g., 1999.99',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: _validatePrice,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Build Description',
                          hintText: 'Enter your build specifications and details...',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _submitBuild,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add Build'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
} 