import 'package:bloc_products/controllers/db/offline/shared_helper.dart';
import 'package:bloc_products/cubits/products/products_state.dart';
import 'package:bloc_products/models/productsEntity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controllers/db/offline/cache_keys.dart';
class ProductsCubit extends Cubit <ProductsState>{
  List<Products>products= [];
  Set<int> favoriteProductIds = {};
  ProductsCubit() : super(InitProductsState());

  void getProducts() async {
    emit(LoadingProductsState());

    try {
      Response response =
      await Dio().get("https://api.escuelajs.co/api/v1/products");

      if (response.statusCode == 200) {
        List<Products> productList = [];

        for (var element in response.data) {
          productList.add(Products.fromJson(element));
        }

        products = productList;
        emit(StopLoadingProductsState());
        emit(SuccessProductsState());
      } else {
        emit(StopLoadingProductsState());
        emit(SuccessProductsState());
      }
    } catch (error) {
      emit(StopLoadingProductsState());
      emit(SuccessProductsState());
    }
  }
  bool isFavorite(int productId) {
    return favoriteProductIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    int index = products.indexWhere((product) => product.id == productId);

    if (index != -1) {
      if (favoriteProductIds.contains(productId)) {
        favoriteProductIds.remove(productId);
      } else {
        favoriteProductIds.add(productId);
      }

      SharedHelper.prefs.setBool(
        '${CacheKeys.isFavorite}_${productId}',
        favoriteProductIds.contains(productId),
      );

      emit(FavoriteToggledProductsState(List.from(products)));
    }
  }

}
