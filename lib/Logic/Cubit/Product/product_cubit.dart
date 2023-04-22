import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_sqllite_impl/Constants/enums.dart';
import 'package:flutter_sqllite_impl/Data/Repositories/product_repository.dart';
import 'package:flutter_sqllite_impl/Data/model/product_response_model.dart';
import 'package:flutter_sqllite_impl/Data/services/api_result.dart';
import 'package:flutter_sqllite_impl/Data/services/network_exceptions.dart';
import 'package:flutter_sqllite_impl/Data/services/sql_helper.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'product_state.dart';

class ProductCubit extends HydratedCubit<ProductState> {
  final ProductRepository productRepository;
  final SQLHelper sqlHelper;

  ProductCubit({
    required this.productRepository,
    required this.sqlHelper,
  }) : super(const ProductState(status: Status.initial));
  // ProductCubit(super.state);

  Future<void> fetchProducts(int pageNo) async {
    emit(state.copyWith(status: Status.loading));
    ApiResult<ProductResponse> aeonianData =
        await productRepository.fetchProducts(pageNo);

    aeonianData.when(success: (ProductResponse data) {
      emit(state.copyWith(status: Status.success, productData: data));
    }, failure: (NetworkExceptions error) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    });
  }

  Future<void> loadCartItems() async {
    emit(state.copyWith(status: Status.cartLoading));
    final List<Product>? cartData = await sqlHelper.getAllProduct();
    num totalValue = 0;

    if (cartData != null) {
      for (final e in cartData) {
        totalValue += (e.price * e.quantity);
      }
      emit(state.copyWith(
        status: Status.cartSuccess,
        cartProduct: cartData,
        cartTotal: totalValue,
      ));
    } else {
      emit(state.copyWith(status: Status.cartFailure));
    }
  }

  Future<void> addToCart(Product data) async {
    emit(state.copyWith(status: Status.cartLoading));
    int id = data.id;
    bool? isPresent;
    state.cartProduct.where((element) {
      if (id == element.id) {
        isPresent = true;
        return false;
      }
      return true;
    });
    data.quantity++;
    final isSuccess = isPresent ?? await sqlHelper.insertProduct(data);
    log("-------isSuccess  $isSuccess-------------");
    if (isSuccess) {
      emit(state.copyWith(status: Status.cartAdded));
      loadCartItems();
    } else {
      emit(state.copyWith(status: Status.cartAddedFail));
    }
  }

  Future<void> deleteCartItem(int id) async {
    emit(state.copyWith(status: Status.cartLoading));

    final isSuccess = await sqlHelper.deleteProduct(id);
    log("-------isSuccess  $isSuccess-------------");
    if (isSuccess) {
      emit(state.copyWith(status: Status.cartUpdated));
      loadCartItems();
    } else {
      emit(state.copyWith(status: Status.cartAddedFail));
    }
  }

  @override
  ProductState? fromJson(Map<String, dynamic> json) {
    return ProductState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ProductState state) {
    return state.toMap();
  }
}
