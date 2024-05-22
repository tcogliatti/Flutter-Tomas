import 'package:products_api/api.dart';

abstract class ProductsRepositoryException implements Exception {
  /// {@macro products_repository_exception}
  const ProductsRepositoryException(this.error, this.stackTrace);

  /// The underlying error that occurred.
  final Object error;

  /// The relevant stack trace.
  final StackTrace stackTrace;
}

/// {@template get_products}
/// Thrown during the get products if a failure occurs.
/// {@endtemplate}
class GetProductsFailure extends ProductsRepositoryException {
  /// {@macro get_products}
  const GetProductsFailure(super.error, super.stackTrace);
}

class ProductsRepository {
  const ProductsRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiClient.getProducts();
      final products = <Product>[];
      for (final product in response['products'] ?? []) {
        products.add(Product.fromJson(product));
      }
      return products;
    } catch (error, stackTrace) {
      throw GetProductsFailure(error, stackTrace);
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await _apiClient.getProductById(id:id);
      final Product product = Product.fromJson(response);
      
      return product;
    } catch (error, stackTrace) {
      throw GetProductsFailure(error, stackTrace);
    }
  }
}
