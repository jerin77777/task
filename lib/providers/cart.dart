import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/models/products.dart';
import '../models/cart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class CartState {
  final List<CartItem> items;
  final int count;
  final double amount;

  CartState({
    required this.items,
    required this.count,
    required this.amount,
  });

  CartState copyWith({List<CartItem>? items, int? count, double? amount}) {
    return CartState(
      items: items ?? this.items,
      count: count ?? this.count,
      amount: amount ?? this.amount,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  static const String _cartStoreName = 'cart_store';
  final _cartStore = StoreRef<String, dynamic>(_cartStoreName);
  late Database _db;

  CartNotifier() : super(CartState(items: [], count: 0, amount: 0)) {
    _initDb();
  }

  Future<void> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'cart.db');

    _db = await databaseFactoryIo.openDatabase(dbPath);

    await _loadCartFromDb(); // Load cart when initializing
  }

  Future<void> _loadCartFromDb() async {
    final record = await _cartStore.record('cart_data').get(_db);

    if (record != null) {
      List<CartItem> savedItems = (record['items'] as List).map((item) => CartItem.fromJson(item)).toList();

      state = state.copyWith(
        items: savedItems,
        count: record['count'],
        amount: record['amount'],
      );
    }
  }

  Future<void> _saveCartToDb() async {
    await _cartStore.record('cart_data').put(_db, {
      'items': state.items.map((item) => item.toJson()).toList(),
      'count': state.count,
      'amount': state.amount,
    });
  }

  // Add item to cart
  void addItem(Product item) {
    int index = state.items.indexWhere((cartItem) => cartItem.id == item.id);
    List<CartItem> updatedItems = List.from(state.items);

    if (index != -1) {
      print("kiar?");
      updatedItems[index] = updatedItems[index].copyWith(qty: updatedItems[index].qty + 1);
    } else {
      updatedItems.add(CartItem(id: item.id, product: item, qty: 1));
    }

    _updateCart(updatedItems);
  }

  // Remove item from cart
  void removeItem(int id) {
    int index = state.items.indexWhere((cartItem) => cartItem.id == id);
    if (index != -1) {
      List<CartItem> updatedItems = List.from(state.items);

      if (updatedItems[index].qty > 1) {
        // Reduce qty by 1
        updatedItems[index] = updatedItems[index].copyWith(qty: updatedItems[index].qty - 1);
      } else {
        // Remove the item if qty becomes zero
        updatedItems.removeAt(index);
      }

      _updateCart(updatedItems);
    }
  }

  // Clear cart
  void clearCart() {
    state = CartState(items: [], count: 0, amount: 0);
    _saveCartToDb(); // Clear cart in DB
  }

  // Calculate total amount and count
  void _updateCart(List<CartItem> updatedItems) {
    double totalAmount = calculateTotal(updatedItems);
    int itemCount = updatedItems.fold(0, (total, item) => total + item.qty);

    state = state.copyWith(
      items: updatedItems,
      count: itemCount,
      amount: totalAmount,
    );

    _saveCartToDb(); // Save updated cart to DB
  }

  // Calculate total price
  double calculateTotal(List<CartItem> items) {
    return items.fold(0, (total, item) {
      double discountedPrice = item.product.price - (item.product.price * (item.product.discount / 100));
      return total + (discountedPrice * item.qty);
    });
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
