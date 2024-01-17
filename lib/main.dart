import 'package:bloc_products/controllers/db/offline/shared_helper.dart';
import 'package:bloc_products/controllers/db/online/dio_helper.dart';
import 'package:bloc_products/cubits/products/products_cubit.dart';
import 'package:bloc_products/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  ProductList(),
      ),
    );
  }
}

