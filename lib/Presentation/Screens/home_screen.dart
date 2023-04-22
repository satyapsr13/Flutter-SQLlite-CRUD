// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqllite_impl/Constants/enums.dart';
import 'package:flutter_sqllite_impl/Logic/Cubit/Product/product_cubit.dart';
import 'package:flutter_sqllite_impl/Presentation/Screens/cart_screen.dart';
import 'package:flutter_sqllite_impl/Utility/next_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<ProductCubit>(context).fetchProducts(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return
        // child:
        Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Mall'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const CartScreen());
              },
              icon: const Icon(
                Icons.shopping_cart,
                size: 20,
                color: Colors.white,
              )),
        ],
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state.status == Status.cartAdded) {
            final snackBar = SnackBar(
              content: const Text('Product Added added'),
              backgroundColor: (Colors.green),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            ////ScaffoldMessenger.of(context).hideCurrentSnackBar();

          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.status == Status.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.status == Status.failure) {
              return Center(
                  child: TextButton(
                onPressed: () {
                  BlocProvider.of<ProductCubit>(context).fetchProducts(1);
                },
                child: Text(
                  'Retry',
                  style: const TextStyle(),
                ),
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: state.productData!.data.length,
                    itemBuilder: (ctx, index) {
                      final product = state.productData!.data[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 10,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Image.network(
                                      product.featuredImage,
                                      fit: BoxFit.cover,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: mq.width * 0.22,
                                        child: Text(
                                          product.title,
                                          style: const TextStyle(),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            BlocProvider.of<ProductCubit>(
                                                    context)
                                                .addToCart(product);
                                          },
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            size: 20,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    //floatingActionButton: FloatingActionButton(onPressed: (){},),
  }
}
