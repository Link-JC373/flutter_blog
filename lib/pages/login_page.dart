import 'package:flutter/material.dart';
import 'package:flutter_shop/style/login_theme.dart';
import 'sign_in_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageView = PageView(
      controller: _pageController,
      children: <Widget>[
        SignInPage(),
        SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //使用SingleChldScrollView + Column，避免弹出键盘时，出现overFlow现象
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(gradient: LoginTheme.primaryGradient),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Icon(Icons.arrow_back),
                Align(
                  alignment: FractionalOffset(0.0, 0.0),
                  child: IconButton(
                    iconSize: 35,
                    icon: Icon(Icons.arrow_back),
                    color: Color(0xFFf7418c),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Image(
                    width: 250,
                    height: 130,
                    image: AssetImage("assets/images/login_logo.png")),
                SizedBox(
                  height: 20,
                ),
                //indicator指示器
                Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Color(0x552B2B2B),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: _currentPage == 0
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  color: Colors.white)
                              : null,
                          child: Center(
                            child: FlatButton(
                              onPressed: () {
                                _pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              },
                              child: Text(
                                "Existing",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: new Container(
                        decoration: _currentPage == 1
                            ? BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: Colors.white,
                              )
                            : null,
                        child: new Center(
                          child: new FlatButton(
                            onPressed: () {
                              _pageController.animateToPage(1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.decelerate);
                            },
                            child: new Text(
                              "New",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Expanded(child: _pageView),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
