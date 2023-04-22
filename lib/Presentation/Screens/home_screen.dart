// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqllite_impl/Constants/enums.dart';
import 'package:flutter_sqllite_impl/Logic/Cubit/Product/product_cubit.dart';
import 'package:flutter_sqllite_impl/Presentation/Screens/cart_screen.dart';
import 'package:flutter_sqllite_impl/Utility/next_screen.dart';
import 'package:flutter_sqllite_impl/Utility/snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  @override
  void initState() {
    BlocProvider.of<ProductCubit>(context).fetchProducts(currentPage);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if ((_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent)) {
      BlocProvider.of<ProductCubit>(context).fetchProducts(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
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
            showSnackBar(context, Colors.green, "Product Added");
            nextScreen(context, CartScreen());
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
            currentPage++;
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: state.productData.length,
                    itemBuilder: (ctx, index) {
                      final product = state.productData[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          elevation: 10,
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                    // height: 100,
                                    width:
                                        mq.width * (islandscape ? 0.1 : 0.25),
                                    child: Image.network(
                                      product.featuredImage,
                                      fit: BoxFit.cover,
                                    )),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: mq.width *
                                            (islandscape ? 0.1 : 0.22),
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
                        crossAxisCount: islandscape ? 4 : 2,
                        childAspectRatio: islandscape ? 5 / 6 : 3 / 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                  ),
                ),
                Visibility(
                    visible: state.status == Status.loadingNextPage,
                    child: SizedBox(
                        height: 70,
                        child: Center(child: CircularProgressIndicator()))),
              ],
            );
          },
        ),
      ),
    );
    //floatingActionButton: FloatingActionButton(onPressed: (){},),
  }
}
