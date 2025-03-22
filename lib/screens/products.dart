import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/globals.dart';
import 'package:task/providers/cart.dart';
import 'package:task/screens/widgets.dart';
// import '../models/products.dart';
import '../providers/products.dart';
import 'cart.dart';

class PaginationNumbers extends ConsumerStatefulWidget {
  const PaginationNumbers({super.key});

  @override
  ConsumerState<PaginationNumbers> createState() => _PaginationNumbersState();
}

class _PaginationNumbersState extends ConsumerState<PaginationNumbers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProductsNumbers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Pallet.background,
      appBar: AppBar(
        title: const Text(
          'Catalogue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Pallet.appbar,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                    if (cartState.count > 0)
                      Transform.translate(
                          offset: Offset(15, -5), //
                          child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(color: Pallet.theme, borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  cartState.count.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w500),
                                ),
                              ))),
                  ],
                )),
          ),
        ],
      ),
      body: productState.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                  shrinkWrap: true, // Wrap grid inside ListView
                  padding: const EdgeInsets.all(5),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.6, // Aspect ratio for item size
                  ),
                  itemCount: productState.products.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(product: productState.products[index]);
                  },
                ),
                PaginationWidget(
                  totalPage: productState.totalPages,
                  currentPage: productState.currentPage,
                )
              ],
            ),
    );
  }
}

class PaginationScroll extends ConsumerStatefulWidget {
  const PaginationScroll({super.key});

  @override
  ConsumerState<PaginationScroll> createState() => _PaginationScrollState();
}

class _PaginationScrollState extends ConsumerState<PaginationScroll> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      final productState = ref.read(productProvider);
      final currentPage = productState.currentPage;
      final totalPages = productState.totalPages;

      if (currentPage < totalPages) {
        ref.read(productProvider.notifier).fetchProductsScroll(page: currentPage + 1);
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productProvider.notifier).fetchProductsScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Pallet.background,
      appBar: AppBar(
        title: const Text(
          'Catalogue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Pallet.appbar,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                child: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                    if (cartState.count > 0)
                      Transform.translate(
                          offset: Offset(15, -5), //
                          child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(color: Pallet.theme, borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  cartState.count.toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w500),
                                ),
                              ))),
                  ],
                )),
          ),
        ],
      ),
      body: productState.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              // physics: const NeverScrollableScrollPhysics(), // Disable scrolling
              // shrinkWrap: true, // Wrap grid inside ListView
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 5,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6, // Aspect ratio for item size
              ),
              itemCount: productState.products.length,
              itemBuilder: (context, index) {
                return ProductWidget(product: productState.products[index]);
              },
            ),
    );
  }
}
