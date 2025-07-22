import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_management_client/core/injection/injection_container.dart'
    as di;
import 'package:product_management_client/core/enum/product_change_type.dart';
import 'package:product_management_client/core/utils/theme.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_detail_bloc/product_detail_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_form_bloc/product_form_event.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_bloc.dart';
import 'package:product_management_client/features/product/presentation/bloc/product_list_bloc/product_list_event.dart';
import 'package:product_management_client/features/product/presentation/pages/product_detail/product_detail_page.dart';
import 'package:product_management_client/features/product/presentation/pages/product_form/product_form_page.dart';
import 'package:product_management_client/features/product/presentation/pages/product_list/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management',
      theme: AppTheme.lightTheme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ProductListBloc>(
            create: (context) => di.sl<ProductListBloc>(),
          ),
        ],
        child: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder:
                  (context) => ProductListPage(
                    onAddProduct:
                        () => _navigatorKey.currentState?.pushNamed(
                          '/product-form',
                          arguments: {'title': 'Add Product'},
                        ),
                    onProductTap:
                        (productId) => _navigatorKey.currentState?.pushNamed(
                          '/product-detail',
                          arguments: {'productId': productId},
                        ),
                  ),
            );

          case '/product-detail':
            final args = settings.arguments as Map<String, dynamic>;
            final productId = args['productId'] as int;
            return MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create:
                        (context) =>
                            di.sl<ProductDetailBloc>()
                              ..add(LoadProductDetailEvent(productId)),
                    child: ProductDetailPage(
                      productId: productId,
                      onEdit:
                          () => _navigatorKey.currentState?.pushNamed(
                            '/product-form',
                            arguments: {
                              'title': 'Edit Product',
                              'productId': productId,
                            },
                          ),
                      onDeleted: (isDeleted) {
                        if (isDeleted) {
                          context.read<ProductListBloc>().add(
                            UpdateProductsAfterDeleteEvent(productId),
                          );
                          _showSuccessSnackBar('Product deleted successfully');
                        }
                      },
                      onBack: () => _navigatorKey.currentState?.pop(),
                    ),
                  ),
            );

          case '/product-form':
            final args = settings.arguments as Map<String, dynamic>;
            final title = args['title'] as String;
            final productId = args['productId'] as int?;
            final type =
                productId != null
                    ? ProductChangeType.editProduct
                    : ProductChangeType.addProduct;

            return MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) {
                      final bloc = di.sl<ProductFormBloc>();
                      if (productId != null) {
                        bloc.add(LoadProductFormEvent(productId, type));
                      }
                      bloc.add(LoadCategoriesFormEvent());
                      return bloc;
                    },
                    child: ProductFormPage(
                      title: title,
                      productId: productId,
                      onChanged: (product, type) {
                        context.read<ProductListBloc>().add(
                          UpdateProductsEvent(product, type),
                        );
                        if (type == ProductChangeType.editProduct) {
                          context.read<ProductDetailBloc>().add(
                            UpdateProductDetailEvent(product),
                          );
                        }
                      },
                    ),
                  ),
            );

          default:
            return MaterialPageRoute(
              builder:
                  (context) => const Scaffold(
                    body: Center(child: Text('Page not found')),
                  ),
            );
        }
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(_navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(message),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }
}
