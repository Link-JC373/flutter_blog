// TODO Implement this library.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/style/login_theme.dart';
import 'package:flutter_shop/utils/provider_modal.dart';
import 'package:flutter_shop/utils/service_method.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusScopeNode focusScopeNode = FocusScopeNode();

  GlobalKey<FormState> _SignInFormKey = GlobalKey();

  bool isShowPassWord = false;

  String userName;
  String passWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              buildSignInTextForm(),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Text(
                  "忘记密码?",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 1,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white10, Colors.white]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        'or',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: 100,
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(colors: [
                        Colors.white,
                        Colors.white10,
                      ])),
                    ),
                  ],
                ),
              ),
              //第三方登录按钮
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.weixin,
                        color: Color(0xFF0084ff),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.qq,
                          color: Color(0xFF0084ff),
                        ),
                        onPressed: null),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            child: buildSignInButton(),
            top: 160,
          )
        ],
      ),
    );
  }

  /*
   * 点击控制密码是否显示
   */
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  //创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      width: 300,
      height: 150,
      child: Form(
        key: _SignInFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 10, bottom: 10),
                child: TextFormField(
                  focusNode: emailFocusNode,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      hintText: "邮箱地址",
                      border: InputBorder.none),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "邮箱不能为空";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                child: TextFormField(
                  focusNode: passwordFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: "密码",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord,
                    ),
                  ),
                  obscureText: !isShowPassWord,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "密码不能为空";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    print(value);
                    setState(() {
                      passWord = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//登录按钮
  Widget buildSignInButton() {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(42, 10, 42, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LoginTheme.primaryGradient),
        child: Text(
          "登录",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () async {
        if (_SignInFormKey.currentState.validate()) {
          _SignInFormKey.currentState.save();
          // signIn();
          var loginData = {
            'userName': userName,
            'passWord': passWord,
          };

          String formData = json.encode(loginData);

          var data = await DioUtil.request('login', formData: formData);

          // if (DioUtil.loading) {
          //   SpinKitRing(color: Colors.blue);
          // }

          data = json.decode(data.toString());

          if (data['status'] == 200) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString('token', data['token']);
            prefs.setInt('userId', data['userId']);

            Provider.of<IsLoginModal>(context).changeLoginState(true);
            Provider.of<IsLoginModal>(context)
                .changeUserId(data['data']['userId']);
            Provider.of<IsLoginModal>(context)
                .changeUserName(data['data']['userName']);

            Navigator.of(context).pop();
          } else {
            return Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${data['message']}'),
              ),
            );
          }
        } else {
          return '';
        }
      },
    );
  }

  void validateSuccsess() {}

  // Widget signIn() {
  //   var loginData = {
  //     'userName': userName,
  //     'passWord': passWord,
  //   };
  //   String formData = json.encode(loginData);

  //   return FutureBuilder(
  //     future: request('login', formData: formData),
  //     builder: (context, snapshot) {
  //       print(123);
  //       if (snapshot.hasData) {
  //         try {
  //           var data = json.decode(snapshot.data.toString());
  //           print(data + '==========================');
  //           // print(data['status']);

  //           if (data['status'] == 200) {
  //             return SnackBar(
  //               content: Text("登录成功"),
  //             );
  //           } else {
  //             return SnackBar(
  //               content: Text("登录失败"),
  //             );
  //           }
  //         } catch (e) {
  //           print(e);
  //           return Column(
  //             children: <Widget>[Text('wrong')],
  //           );
  //         }
  //       } else {
  //         return SpinKitRing(color: Colors.blue);
  //       }
  //     },
  //   );
  // }
}
