import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../globals.dart';
import '../models/products.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class PaginationWidget extends ConsumerStatefulWidget {
  final int totalPage;
  final int currentPage;

  const PaginationWidget({
    super.key,
    required this.totalPage,
    required this.currentPage,
  });

  @override
  ConsumerState<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends ConsumerState<PaginationWidget> {
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    selectedPage = widget.currentPage;
  }

  void onPageTap(int pageNumber) {
    setState(() {
      selectedPage = pageNumber;
    });
    ref.read(productProvider.notifier).fetchProductsNumbers(page: pageNumber);
  }

  void goToPreviousPage() {
    if (selectedPage > 1) {
      onPageTap(selectedPage - 1);
    }
  }

  void goToNextPage() {
    if (selectedPage < widget.totalPage) {
      onPageTap(selectedPage + 1);
    }
  }

  List<int> getDisplayedPages() {
    if (widget.totalPage <= 4) {
      return List.generate(widget.totalPage, (index) => index + 1);
    }

    if (selectedPage <= 3) {
      return [1, 2, 3, 4, widget.totalPage];
    } else if (selectedPage >= widget.totalPage - 2) {
      return [1, widget.totalPage - 3, widget.totalPage - 2, widget.totalPage - 1, widget.totalPage];
    } else {
      return [1, selectedPage - 1, selectedPage, selectedPage + 1, widget.totalPage];
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedPages = getDisplayedPages();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Previous arrow
          GestureDetector(
            onTap: goToPreviousPage,
            child: Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: selectedPage > 1 ? Colors.grey[300] : Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 12,
                color: Colors.black,
              ),
            ),
          ),
          ...displayedPages.map((pageNumber) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () => onPageTap(pageNumber),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: pageNumber == selectedPage ? Pallet.theme : Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      '$pageNumber',
                      style: TextStyle(
                        color: pageNumber == selectedPage ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          // Next arrow
          GestureDetector(
            onTap: goToNextPage,
            child: Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: selectedPage < widget.totalPage ? Colors.grey[300] : Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductWidget extends ConsumerWidget {
  const ProductWidget({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Pallet.background.withOpacity(0.4),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: Pallet.theme,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addItem(product);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Set border radius here
                        ),
                        backgroundColor: Color(0xFFF5F5F5),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(80, 33),
                        maximumSize: const Size(80, 33)),
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 13, color: Pallet.theme, fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  product.brand,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                // Price Row with Original Price and Discount
                Row(
                  children: [
                    Text(
                      "₹${product.originalPrice.toString()}",
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Pallet.font2,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "₹${product.price.toString()}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Discount Badge
                RichText(
                  text: TextSpan(
                    text: '${product.discount}% ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Pallet.theme,
                      fontSize: 11.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'OFF',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Pallet.theme,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
