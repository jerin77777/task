import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/products.dart';

class ProductState {
  final List<Product> products;
  final int totalPages;
  final int currentPage;

  ProductState({
    required this.products,
    required this.totalPages,
    required this.currentPage,
  });

  ProductState copyWith({
    List<Product>? products,
    int? totalPages,
    int? currentPage,
  }) {
    return ProductState(
      products: products ?? this.products,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier() : super(ProductState(products: [], totalPages: 1, currentPage: 1));

  bool _isFetching = false;
  final int _limit = 8; // Items per page
  int totalPages = 1; // To store the total number of pages

  Future<void> fetchProductsNumbers({int page = 1}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      reset();
      final response = await Dio().get(
        'https://dummyjson.com/product',
        queryParameters: {
          'limit': _limit,
          'skip': (page - 1) * _limit,
        },
      );

      final List<Product> fetchedProducts =
          (response.data["products"] as List).map((item) => Product.fromJson(item)).toList();

      // // Update total pages if available
      final int totalProducts = response.data["total"] ?? 0;
      totalPages = (totalProducts / _limit).ceil();

      state = state.copyWith(
        products: fetchedProducts,
        totalPages: totalPages,
        currentPage: page,
      );
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isFetching = false;
    }
  }

  Future<void> fetchProductsScroll({int page = 1}) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (page == 1) {
        reset();
      }
      final response = await Dio().get(
        'https://dummyjson.com/products',
        queryParameters: {
          'limit': _limit,
          'skip': (page - 1) * _limit,
        },
      );

      final List<Product> fetchedProducts =
          (response.data["products"] as List).map((item) => Product.fromJson(item)).toList();

      // Update total pages if available
      final int totalProducts = response.data["total"] ?? 0;
      final int totalPages = (totalProducts / _limit).ceil();

      // Append new products to the existing list
      final allProducts = [...state.products, ...fetchedProducts];

      state = state.copyWith(
        products: allProducts,
        totalPages: totalPages,
        currentPage: page,
      );
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isFetching = false;
    }
  }

  void reset() {
    state = state.copyWith(
      totalPages: 1,
      currentPage: 1,
      products: [],
    );
  }
}

// Riverpod provider
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});
