import 'package:flutter/foundation.dart';
import 'package:products_api/api.dart';
import 'package:products_repository/products_repository.dart';

class FavoritesModel extends ChangeNotifier {
  /// The private field backing [catalog].
  // late CatalogModel _catalog;
  late ProductsRepository _catalog;

  /// Internal, private state of the favorites. 
  final List<Product> _items = [];

  ProductsRepository get catalog => _catalog;

  set catalog(ProductsRepository newCatalog) {
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of Products in the cart.
  List<Product> get items => _items;

  /// Adds [Product] to cart. This is the only way to modify the cart from outside.
  void add(Product item) {
    _items.add(item);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(Product item) {
    _items.remove(item);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}
