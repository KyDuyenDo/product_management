import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/domain/entities/product.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_state.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/max_images_snack_bar.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/content/product_form_widget.dart';
import 'package:product_management_client/features/product/presentation/widgets/dialog_utils.dart';
import 'package:product_management_client/features/product/presentation/widgets/submit_loading.dart';

class ProductFormPage extends StatelessWidget {
  final String title;
  final int? productId;
  final VoidCallback? onChanged;

  const ProductFormPage({
    super.key,
    required this.title,
    this.productId,
    this.onChanged,
  });

  bool get _isEdit => productId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                scrolledUnderElevation: 0,
                expandedHeight: 120,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          DefaultColors.buttonColor,
                          DefaultColors.buttonColor.withValues(alpha: 0.8),
                          DefaultColors.highlightTitle,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(70, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _isEdit
                                        ? Icons.edit_outlined
                                        : Icons.add_box_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isEdit
                                            ? 'Edit Product'
                                            : 'Add New Product',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        _isEdit
                                            ? 'Update product information'
                                            : 'Create a new product for your store',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BlocConsumer<ProductFormBloc, ProductFormState>(
                  listener: (context, state) {
                    if (state.isChanged &&
                        !state.isLoading &&
                        !state.isUploadingImages) {
                      if (_isEdit) {
                        DialogUtils.showProductUpdated(context).then((_) {
                          Navigator.of(context).pop();
                        });
                      } else {
                        DialogUtils.showProductCreated(context).then((_) {
                          Navigator.of(context).pop();
                        });
                      }
                      onChanged?.call();
                    }

                    if (state.errorMessage != null) {
                      DialogUtils.showGenericError(
                        context,
                        message: state.errorMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading && state.product == null && _isEdit) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(50),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state.isUploadingImages) {
                      return Container(
                        padding: const EdgeInsets.all(50),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              'Uploading images... ${(state.uploadProgress * 100).toInt()}%',
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: state.uploadProgress,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                DefaultColors.buttonColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ProductFormWidget(
                      categories: state.categories,
                      product: state.product,
                      productId: productId,
                      submitButtonText: title,
                      onSubmit: (productData, images) {
                        final product = Product(
                          id: productData['id'],
                          name: productData['name'],
                          description: productData['description'],
                          price: productData['price'],
                          stock: productData['stock'],
                          categoryId: productData['category_id'],
                          categoryName: productData['category_name'],
                          thumbnail: productData['thumbnail'],
                          images: List<String>.from(productData['images']),
                          stockStatus: productData['stock_status'],
                        );

                        if (_isEdit) {
                          context.read<ProductFormBloc>().add(
                            EditProductEvent(product, productId!, images),
                          );
                        } else {
                          context.read<ProductFormBloc>().add(
                            AddProductEvent(product, images),
                          );
                        }
                      },
                      onMaxImagesReached: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(MaxImagesSnackBar.build());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          BlocBuilder<ProductFormBloc, ProductFormState>(
            builder: (context, state) {
              if (state.isSubmitting) {
                return SubmitLoading(
                  title:
                      _isEdit ? 'Updating product...' : 'Creating product...',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
