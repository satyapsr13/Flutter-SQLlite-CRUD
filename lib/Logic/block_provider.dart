import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sqllite_impl/Data/Repositories/product_repository.dart';
import 'package:flutter_sqllite_impl/Data/services/sql_helper.dart';
import 'package:flutter_sqllite_impl/Logic/Cubit/Product/product_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'Cubit/About/product_cubit.dart';

Future<List<BlocProvider>> getBlocProviders(
    HydratedStorage hydratedStorage) async {
  // system utilities
  final Connectivity connectivity = Connectivity();
  final ProductRepository productRepository = ProductRepository();
  final SQLHelper sqlHelper = SQLHelper();
  return [
    BlocProvider<ProductCubit>(
        create: (context) => ProductCubit(
            productRepository: productRepository, sqlHelper: sqlHelper)),
  ];
}
