// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqllite_impl/Constants/enums.dart';
import 'package:flutter_sqllite_impl/Logic/Cubit/Product/product_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    BlocProvider.of<ProductCubit>(context).loadCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          height: 70,
          width: mq.width,
          color: Colors.blue.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Total ",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  "\$ ${state.cartTotal}",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Builder(builder: (context) {
          if (state.status == Status.cartLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == Status.cartFailure) {
            return Center(
                child: TextButton(
              onPressed: () {
                BlocProvider.of<ProductCubit>(context).loadCartItems();
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
                child: ListView.builder(
                  itemCount: state.cartProduct.length,
                  itemBuilder: (ctx, index) {
                    final product = state.cartProduct[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Row(
                          children: [
                            SizedBox(
                              width: mq.width * 0.45,
                              height: mq.height * 0.2,
                              child: Image.network(
                                product.featuredImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: mq.width * 0.4,
                                    child: Text(
                                      product.title,
                                      style: const TextStyle(),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Price \$${product.price}",
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Quantity  ${product.quantity}",
                                    style: const TextStyle(),
                                  ),
                                  const SizedBox(height: 10),
                                  IconButton(
                                      onPressed: () {
                                        BlocProvider.of<ProductCubit>(context)
                                            .deleteCartItem(product.id);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
        //floatingActionButton: FloatingActionButton(onPressed: (){},),
      );
    });
  }
}
