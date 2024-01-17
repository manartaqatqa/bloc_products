import 'package:bloc_products/cubits/products/products_state.dart';
import 'package:bloc_products/cubits/products/products_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is InitProductsState) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ProductsCubit>(context).getProducts();
                },
                child: Text('Load Products'),
              ),
            );
          }
          else if (state is LoadingProductsState || state is StopLoadingProductsState) {
            return Center(child: CircularProgressIndicator());
          }
          else if (state is SuccessProductsState) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsScreen(),
                    ),
                  );
                },
                child: Text('View Products'),
              ),
            );
          }
          else {
            return Center(child: Text('Unknown State'));
          }
        },
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsCubit = BlocProvider.of<ProductsCubit>(context);
    final products = productsCubit.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products Screen'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 17),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  width: 70.0,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            products[index].images![0] ?? "",
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products[index].title ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                '\$ ${products[index].price ?? ""}',
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () {
                    productsCubit.toggleFavorite(products[index].id!);
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: BlocBuilder<ProductsCubit, ProductsState>(
                      builder: (context, state) {
                        if (state is FavoriteToggledProductsState) {
                          bool isFavorite = productsCubit.isFavorite(products[index].id!);
                          return Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          );
                        } else {
                          return Icon(Icons.favorite_border, color: Colors.red);
                        }
                      },
                    ),
                  ),
                ),


              ),
              onTap: () {
              },
            ),
          );
        },
      ),
    );
  }
}
