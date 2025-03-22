import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../globals.dart';
import '../providers/cart.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Pallet.background,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Pallet.appbar,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartState.items.length,
              itemBuilder: (context, index) {
                final item = cartState.items[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
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
                        imageUrl: item.product.image,
                        width: 120,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              item.product.brand,
                              maxLines: 1,
                              style: const TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: [
                                Text(
                                  "₹${item.product.originalPrice.toString()}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                    color: Pallet.font2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "₹${item.product.price.toString()}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            RichText(
                              text: TextSpan(
                                text: '${item.product.discount}% ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Pallet.theme,
                                  fontSize: 12,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'OFF',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Pallet.theme,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Pallet.inside1,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ref.read(cartProvider.notifier).removeItem(item.product.id);
                                        },
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(child: Icon(Icons.remove, size: 18)),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        item.qty.toString(),
                                        style: TextStyle(color: Pallet.theme, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                        onTap: () {
                                          ref.read(cartProvider.notifier).addItem(item.product);
                                        },
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(child: Icon(Icons.add, size: 18)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10)
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount Price',
                        style: const TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹${cartState.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Check Out',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            cartState.count.toString(),
                            style: TextStyle(fontSize: 9.5, color: Pallet.theme, fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Set border radius here
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: Pallet.theme,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(130, 50),
                      maximumSize: const Size(130, 50)),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }
}
