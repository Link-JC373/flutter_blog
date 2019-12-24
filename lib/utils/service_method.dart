import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/utils/httpHeaders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

class DioUtil {
  static Dio dio = new Dio();
  static bool loading = false;
  static Future request(url, {formData, context}) async {
    try {
      // Options options = Options(headers: {HttpHeaders.acceptHeader:"accept: application/json"});

      print('开始获取数据...............');
      loading = true;
      Response response;
      dio.options.responseType = ResponseType.plain;
      dio.options.headers = httpHeaders;
      tokenInter();
//  dio.options.contentType = ContentType.parse("application/json;charset=UTF-8")
      print(servicePath[url]);

      if (formData == null) {
        response = await dio.post(servicePath[url]);
      } else {
        response = await dio.post(servicePath[url], data: formData);
        print(response);
      }

      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        print(responseData);

        //判断是否有权限，
        if (responseData['status'] == 401) {
          print(123);
          Application.router.navigateTo(context, '/login');
          loading = false;

          return null;
        }

        loading = false;
        return response.data;
      } else {
        loading = false;

        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    } catch (e) {
      return print('ERROR:======>$e');
    }
  }

  static tokenInter() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) {
          dio.lock();
          Future<dynamic> future = Future(() async {
            print("请求拦截开始");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            return prefs.getString('token');
          });
          return future.then((value) {
            options.headers["token"] = value;
            return options;
          }).whenComplete(() => dio.unlock());
        },
      ),
    );
  }
}

// Function isPermisson(permission) {
//   permission = json.decode(permission);
//   if (permission['status'] == 401) {
//     // Application.router.navigateTo();

//   }
// }
