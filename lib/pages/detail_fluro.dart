import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_shop/utils/provider_modal.dart';
import 'package:flutter_shop/utils/service_method.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const APPBAE_SCROLL_OFFSET = 100;

class DetailsPage extends StatefulWidget {
  final String articleId;
  final int userId;

  const DetailsPage(
    this.articleId,
    this.userId, {
    Key key,
  }) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState(articleId, userId);
}

class _DetailsPageState extends State<DetailsPage> {
  final String articleId;
  final int userId;

  _DetailsPageState(this.articleId, this.userId);
  // DetailsPage(this.articleId);

  bool isChangeBar = true;

//滚动改变标题
  // _onScroll(offset) {
  //   double alpha = offset / APPBAE_SCROLL_OFFSET;
  //   if (alpha == 0) {
  //     setState(() {
  //       isChangeBar = true;
  //     });
  //   }
  //   if (alpha > 0 && isChangeBar == true) {
  //     setState(() {
  //       isChangeBar = false;
  //     });
  //   }
  // }

  var param = {
    'id': '0',
    'userId': 0,
  };
  String formData = '';
  var _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      param = {
        'id': articleId,
        'userId': userId,
      };
    });
    formData = json.encode(param);
    _futureBuilderFuture =
        DioUtil.request('getArticleDetail', formData: formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: isChangeBar
        //     ? Text(
        //         '文章详情页',
        //         style: TextStyle(color: Colors.black),
        //       )
        //     : null,
        title: Text(
          '文章详情页',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        // textTheme: TextTheme(),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: NotificationListener(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollUpdateNotification) {
              //原想仿掘金，随着屏幕滑动更改标题内容,技术有限没有实现。等以后看看能不能实现
              // _onScroll(scrollNotification.metrics.pixels);
            }
            return false;
          },
          child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  // var data = json.decode(snapshot.data.toString());
                  // print(data);
                  Provider.of<IsLoginModal>(context).changeArticleData(
                    json.decode(snapshot.data.toString()),
                  );

                  return ArticleMarkDown();
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
  // final data;

  // const ArticleMarkDown(
  //   this.data, {
  //   Key key,
  // }) : super(key: key);

  @override
  _ArticleMarkDownState createState() => _ArticleMarkDownState();
}

class _ArticleMarkDownState extends State<ArticleMarkDown>
    with AutomaticKeepAliveClientMixin {
  // _ArticleMarkDownState(this.data);
  bool get wantKeepAlive => true;
  // final data;

  FocusNode blankNode = FocusNode();
  // FocusNode textNode = FocusNode();

  bool isFocus = false;
  @override
  void initState() {
    super.initState();
    // textNode.addListener(() {});
    blankNode.addListener(() {
      // print("焦点1是否被选中："+blankNode.hasFocus.toString());
      Future.delayed(Duration(milliseconds: 100));

      setState(() {
        isFocus = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(blankNode);
      },
      child: contentBody(),
    );
  }

  Widget contentBody() {
    final providerModal = Provider.of<IsLoginModal>(context);
    var md = providerModal.articleData['data']['article_content'];
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            // height: 100.0,
            child: ListView(
              children: <Widget>[
                Text('这里放作者简介'),
                MarkdownBody(
                  data: md,
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
    print("============================");
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
    final providerModal = Provider.of<IsLoginModal>(context);
    // bool reLike = providerModal.articleData['data']['isLike'];
    int likeCount = int.parse(providerModal.articleData['data']['likeCount']);
    print(providerModal.articleData['data']['likeCount']);
    var addPointData = {
      'articleId': providerModal.articleData['data']['id'].toString(),
      'userId': providerModal.userId
    };

    String formData = json.encode(addPointData);

    Future<bool> onLikeButtonTap(bool isLiked) async {
      ///send your request here
      ///
      print(isLiked);
      if (isLiked) {
        await DioUtil.request(
          'reduceArticlePoint',
          formData: formData,
          // context: context,
        );
      } else {
        await DioUtil.request(
          'addArticlePoint',
          formData: formData,
          // context: context,
        );
      }
      isLiked = !isLiked;
      likeCount = isLiked ? likeCount - 1 : likeCount + 1;

      final Completer<bool> completer = new Completer<bool>();
      // print(providerModal.articleData['data']['likeCount']);
      // print(providerModal.articleData['data']['isLike']);

      // print("+++++++++++++++++++++++++++++++++++");
      // // providerModal.articleData['data']['isLike'] =
      // //     !providerModal.articleData['data']['isLike'];

      // // providerModal.articleData['data']['likeCount'] = likeCount.toString();
      // print(providerModal.articleData['data']['likeCount']);
      // print(providerModal.articleData['data']['isLike']);

      // providerModal.changeArticleData(providerModal.articleData);

      completer.complete(isLiked);

      return completer.future;
    }

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: RaisedButton(
            child: Text('click'),
            onPressed: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              if (!providerModal.isLogin) {
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
              LikeButton(
                isLiked: providerModal.articleData['data']['isLike'],
                likeBuilder: (bool isLiked) {
                  return Icon(
                    FontAwesomeIcons.thumbsUp,
                    color: isLiked ? Colors.blue : Colors.grey,
                  );
                },
                likeCount: likeCount,
                onTap: (bool isLiked) {
                  if (providerModal.isLogin) {
                    return onLikeButtonTap(isLiked);
                  } else {
                    Application.router.navigateTo(context, '/login');
                  }
                },
              ),
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
