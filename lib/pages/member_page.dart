import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/utils/provider_modal.dart';
import 'package:flutter_shop/utils/service_method.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  // bool isLogin = false;

  @override
  void initState() {
    super.initState();
    // checkIsLogin();
  }

  // checkIsLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   if (prefs.getString('token') != null) {
  //     setState(() {
  //       isLogin = true;
  //     });
  //   }
  // }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Provider.of<IsLoginModal>(context).changeLoginState(false);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final providerModal = Provider.of<IsLoginModal>(context);
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text('ME!'),
          centerTitle: true,
        ),
        preferredSize: Size.fromHeight(screenSize.height * 0.05),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            providerModal.isLogin
                ? Text('已登录')
                : Container(
                    child: RaisedButton(
                      child: Text('登录'),
                      onPressed: () {
                        Application.router.navigateTo(
                          context,
                          '/login',
                          // transition: TransitionType.fadeIn,
                        );
                      },
                    ),
                  ),
            providerModal.isLogin
                ? RaisedButton(
                    child: Text('退出登录'),
                    onPressed: () {
                      logOut();
                    },
                  )
                : Text('未登录'),
            Container(
              child: RaisedButton(
                child: Text('commentTest'),
                onPressed: () {
                  // Application.router.navigateTo(
                  //   context,
                  //   '/comment',
                  //   transition: TransitionType.fadeIn,
                  // );
                  DioUtil.request('comment', context: context).then((value) {
                    print(value);
                    return null;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
