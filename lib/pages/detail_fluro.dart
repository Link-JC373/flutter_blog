import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/utils/service_method.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

const APPBAE_SCROLL_OFFSET = 100;

class DetailsPage extends StatefulWidget {
  final String articleId;

  const DetailsPage(
    this.articleId, {
    Key key,
  }) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState(articleId);
}

class _DetailsPageState extends State<DetailsPage> {
  final String articleId;

  _DetailsPageState(this.articleId);
  // DetailsPage(this.articleId);

  bool isChangeBar = true;

//滚动改变标题
  _onScroll(offset) {
    double alpha = offset / APPBAE_SCROLL_OFFSET;
    if (alpha == 0) {
      setState(() {
        isChangeBar = true;
      });
      // isChangeBar = true;
      print(isChangeBar);
    }
    if (alpha > 0 && isChangeBar == true) {
      setState(() {
        isChangeBar = false;
      });
      // isChangeBar = false;
      print(isChangeBar);
    }
    print(alpha);
  }

  var param = {
    'id': '1',
  };
  String formData = '';
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      param = {'id': articleId};
    });
    formData = json.encode(param);
    _futureBuilderFuture =
        DioUtil.request('getArticleDetail', formData: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isChangeBar
            ? Text(
                '文章详情页',
                style: TextStyle(color: Colors.black),
              )
            : null,
        backgroundColor: Colors.white,
        // textTheme: TextTheme(),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: NotificationListener(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              _onScroll(scrollNotification.metrics.pixels);
            }
            return false;
          },
          child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  var data = json.decode(snapshot.data.toString());
                  print(data);
                  return ArticleMarkDown(data);
                } catch (e) {
                  print(e);
                  return Column(
                    children: <Widget>[Text('wrong')],
                  );
                }
              } else {
                return SpinKitRing(color: Colors.blue);
              }
            },
          ),
        ),
        // child: ArticleMarkDown(formData),

        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      ),
    );
  }
}

//文章内容控件
class ArticleMarkDown extends StatefulWidget {
  final data;

  const ArticleMarkDown(
    this.data, {
    Key key,
  }) : super(key: key);

  @override
  _ArticleMarkDownState createState() => _ArticleMarkDownState(data);
}

class _ArticleMarkDownState extends State<ArticleMarkDown> {
  _ArticleMarkDownState(this.data);

  final data;

  // const ArticleMarkDown(this.formData);
  var _futureBuilderFuture;

  FocusNode blankNode = FocusNode();
  // FocusNode textNode = FocusNode();

  bool isFocus = false;
  @override
  void initState() {
    super.initState();
    // textNode.addListener(() {});
    blankNode.addListener(() {
      // print("焦点1是否被选中："+blankNode.hasFocus.toString());
      setState(() {
        isFocus = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: contentBody(data),
    );
  }

  Widget contentBody(data) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            // height: 100.0,
            child: ListView(
              children: <Widget>[
                Text('这里放作者简介'),
                MarkdownBody(
                  data: data['data']['article_content'],
                ),
                ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text('这里要写评论'),
                    Text('这里要写评论'),
                    Text('这里要写评论'),
                    Text('这里要写评论'),
                    Text('这里要写评论'),
                  ],
                ),
              ],
            ),
          ),
        ),
        isFocus ? afterForcus() : beforeForcus()
      ],
    );
  }

  Widget afterForcus() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            autofocus: true,
          ),
        ),
      ],
    );
  }

  Widget beforeForcus() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RaisedButton(
            child: Text('click'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString('token') == null) {
                Application.router.navigateTo(context, '/login');
              } else {
                setState(() {
                  isFocus = true;
                });
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.thumb_up),
                iconSize: 16,
                onPressed: () {},
              ),
              Text('666'),
              IconButton(
                icon: Icon(Icons.message),
                iconSize: 16,
                onPressed: () {},
              ),
              Text('233'),
            ],
          ),
        ),
      ],
    );
  }
}
