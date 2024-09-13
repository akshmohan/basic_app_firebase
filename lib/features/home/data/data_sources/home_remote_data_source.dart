import 'dart:convert';
import 'package:mechine_test_flutter/core/errors/server_exception.dart';
import 'package:mechine_test_flutter/features/home/data/models/product_model.dart';
import 'package:http/http.dart' as http;

abstract interface class HomeRemoteDataSource {
  Future<List<ProductModel>> fetchDataFromApi();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<List<ProductModel>> fetchDataFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        List<ProductModel> data = [];

        List result = jsonDecode(response.body);

        result.map((e) => data.add(ProductModel.fromJson(e))).toList();

        return data;
      } else {
        throw ServerException("Something went wrong!");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
