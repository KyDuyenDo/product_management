import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/features/product/presentation/widgets/carousel.dart';
import 'package:product_management_client/features/product/presentation/widgets/expandable_floating_action_button.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_state.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_event.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/empty_view.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/error_view.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/loading_view.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/product_header_card.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/product_info_card.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/content/product_stats_row.dart';
import 'package:product_management_client/features/product/presentation/widgets/submit_loading.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
    this.onEdit,
    this.onDeleted,
    this.onBack,
    this.onProductUpdated,
  });

  final int productId;
  final VoidCallback? onEdit;
  final Function(bool)? onDeleted;
  final VoidCallback? onBack;
  final VoidCallback? onProductUpdated;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _refreshProductDetail();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _refreshProductDetail();
      });
    }
  }

  void _refreshProductDetail() {
    context.read<ProductDetailBloc>().add(
      RefreshProductDetailEvent(widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null && !state.isDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!)),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        context.read<ProductDetailBloc>().add(
                          DeleteProductEvent(widget.productId),
                        );
                      },
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }

          if (state.isDeleted) {
            Future.delayed(const Duration(milliseconds: 100), () {
              widget.onDeleted?.call(true);
              _handleBack();
            });
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.product == null) {
            return const ProductDetailLoadingView();
          }

          if (state.product == null && state.errorMessage != null) {
            return ProductDetailErrorView(
              message: state.errorMessage!,
              onRetry:
                  () => context.read<ProductDetailBloc>().add(
                    LoadProductDetailEvent(widget.productId),
                  ),
            );
          }

          if (state.product != null) {
            return _buildProductDetail(state);
          }

          return const ProductDetailEmptyView();
        },
      ),
      floatingActionButton: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state.product != null && !state.isDeleting) {
            return ExpandableFloatingActionButton(
              onEdit: widget.onEdit,
              onDelete:
                  () => context.read<ProductDetailBloc>().add(
                    DeleteProductEvent(widget.productId),
                  ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!.call();
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildProductDetail(ProductDetailState state) {
    final product = state.product!;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              scrolledUnderElevation: 0,
              expandedHeight: 400,
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
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: _handleBack,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Carousel(
                    expandToFill: false,
                    images: product.images.isNotEmpty ? product.images : null,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.grey[50],
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ProductHeaderCard(product: product),
                    const SizedBox(height: 20),
                    ProductInfoCard(product: product),
                    const SizedBox(height: 20),
                    ProductStatsRow(product: product),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (state.isDeleting) SubmitLoading(title: "Deleting product..."),
      ],
    );
  }
}
