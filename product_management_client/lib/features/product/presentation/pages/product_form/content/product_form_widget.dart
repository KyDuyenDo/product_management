import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_management_client/features/product/domain/entities/category.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/presentation/model/image_item.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/image_picker_bottom.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/images_section.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/info_section.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/pricing_stock_section.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/submit_button_section.dart';

class ProductFormWidget extends StatefulWidget {
  final String submitButtonText;
  final int? productId;
  final Function(Map<String, dynamic>, List<XFile>) onSubmit;
  final VoidCallback? onMaxImagesReached;
  final List<Category> categories;
  final Product? product;

  const ProductFormWidget({
    super.key,
    required this.submitButtonText,
    this.productId,
    required this.onSubmit,
    this.onMaxImagesReached,
    required this.categories,
    this.product,
  });

  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  int? _selectedCategory;
  final List<ImageItem> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeForm();
    }
  }

  @override
  void didUpdateWidget(ProductFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.product != null && oldWidget.product != widget.product) {
      _initializeForm();
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.product != null) {
      _productNameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();

      setState(() {
        _selectedCategory = widget.product!.categoryId;
        _selectedImages.clear();
        for (String imageUrl in widget.product!.images) {
          _selectedImages.add(ImageItem.fromUrl(imageUrl));
        }
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (_selectedImages.length >= 5) {
      widget.onMaxImagesReached?.call();
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImages.add(ImageItem.fromXFile(image));
      });
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final int remainingSlots = 5 - _selectedImages.length;

    if (remainingSlots <= 0) {
      widget.onMaxImagesReached?.call();
      return;
    }

    final List<XFile> images = await _picker.pickMultiImage();

    if (images.isNotEmpty) {
      if (images.length + _selectedImages.length > 5) {
        final List<XFile> allowedImages = images.take(remainingSlots).toList();

        setState(() {
          for (XFile image in allowedImages) {
            _selectedImages.add(ImageItem.fromXFile(image));
          }
        });

        if (images.length > remainingSlots) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Only $remainingSlots more images can be added. Maximum 5 images allowed.',
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } else {
        setState(() {
          for (XFile image in images) {
            _selectedImages.add(ImageItem.fromXFile(image));
          }
        });
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ImagePickerBottomSheet(
          onCameraSelected: () {
            Navigator.pop(context);
            _pickImageFromCamera();
          },
          onGallerySelected: () {
            Navigator.pop(context);
            _pickImagesFromGallery();
          },
        );
      },
    );
  }

  void _submitForm() {
    setState(() {
      _categoryError = null;
    });

    bool isFormValid = _formKey.currentState!.validate();

    if (_selectedCategory == null) {
      setState(() {
        _categoryError = 'Please select a category';
      });
      isFormValid = false;
    }

    if (!isFormValid) return;

    final existingImages =
        _selectedImages
            .where((item) => item.isExisting)
            .map((item) => item.url!)
            .toList();

    final newImages =
        _selectedImages
            .where((item) => item.isNewFile)
            .map((item) => item.xFile!)
            .toList();

    final productData = {
      'id': widget.productId ?? Random().nextInt(100000),
      'name': _productNameController.text,
      'description': _descriptionController.text,
      'price': int.parse(_priceController.text),
      'stock': int.parse(_stockController.text),
      'category_id': _selectedCategory,
      'category_name':
          widget.categories
              .firstWhere((cat) => cat.id == _selectedCategory)
              .name,
      'thumbnail':
          _selectedImages.isNotEmpty
              ? (_selectedImages.first.isExisting
                  ? _selectedImages.first.url
                  : 'https://via.placeholder.com/300')
              : 'https://via.placeholder.com/300',
      'images': existingImages,
      'stock_status':
          int.parse(_stockController.text) > 0 ? 'In Stock' : 'Out of Stock',
    };

    widget.onSubmit(productData, newImages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            BasicInfoSection(
              productNameController: _productNameController,
              descriptionController: _descriptionController,
              productNameValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
              descriptionValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                if (value.length > 500) {
                  return 'Description cannot exceed 500 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            PricingStockSection(
              priceController: _priceController,
              stockController: _stockController,
              selectedCategory: _selectedCategory,
              categories: widget.categories,
              categoryError: _categoryError,
              priceValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                final price = int.tryParse(value);
                if (price == null) {
                  return 'Price must be a valid number';
                }
                if (price <= 0) {
                  return 'Price must be greater than 0';
                }
                if (price > 1000000) {
                  return 'Price cannot exceed 1,000,000';
                }
                if (price % 1000 != 0) {
                  return 'Price must be a multiple of 1,000';
                }
                return null;
              },
              stockValidator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter stock quantity';
                }
                final stock = int.tryParse(value);
                if (stock == null) {
                  return 'Stock must be a valid number';
                }
                if (stock < 0) {
                  return 'Stock cannot be negative';
                }
                if (stock > 10000) {
                  return 'Stock cannot exceed 10,000';
                }
                return null;
              },
              onCategoryChanged: (int? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                  _categoryError = null;
                });
              },
            ),
            const SizedBox(height: 20),
            ImagesSection(
              selectedImages: _selectedImages,
              onAddImage: _showImagePickerBottomSheet,
              onRemoveImage: _removeImage,
            ),
            const SizedBox(height: 40),
            SubmitButtonSection(
              submitButtonText: widget.submitButtonText,
              onSubmit: _submitForm,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
