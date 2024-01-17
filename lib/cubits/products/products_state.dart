import 'package:bloc_products/models/productsEntity.dart';

abstract class ProductsState{}

class InitProductsState extends ProductsState{}
class LoadingProductsState extends ProductsState{}
class SuccessProductsState extends ProductsState{}
class StopLoadingProductsState extends ProductsState{}
class FavoriteToggledProductsState extends ProductsState {
  final List<Products> products;
  FavoriteToggledProductsState(this.products);
}
