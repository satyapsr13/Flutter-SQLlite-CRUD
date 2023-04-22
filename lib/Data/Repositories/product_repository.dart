import 'dart:convert';
import 'dart:developer';

import 'package:flutter_sqllite_impl/Data/model/product_response_model.dart';
import 'package:flutter_sqllite_impl/Data/services/api_result.dart';
import 'package:flutter_sqllite_impl/Data/services/dio_client.dart';
import 'package:flutter_sqllite_impl/Data/services/network_exceptions.dart';

class ProductRepository {
  late DioClient dioClient;

  ProductRepository() {
    dioClient = DioClient();
  }

  Future<ApiResult<ProductResponse>> fetchProducts(int pageNo) async {
    Map data = {"page": pageNo, "perPage": 5};

    try {
      final response = await dioClient.post(
        "/product_list.php",
        data: data,
      );
      ProductResponse productResponse =
          ProductResponse.fromMap(json.decode(response));
      log("***** Category ** Response *****-> [${response.runtimeType} ]****************************");
      return ApiResult.success(data: productResponse);
    } catch (e) {
      log("***** Category ** Response **error *****-> [$e ]****************************");
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
