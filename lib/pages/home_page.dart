import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/search_part.dart';
import 'package:flutter_shop/routers/application.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../utils/service_method.dart';
import 'show_article_list.dart';

const APPBAE_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final List<Widget> tabs = <Widget>[
    Text('推荐'),
    Text('视频教程'),
    Text('学习'),
    Text('娱乐'),
  ];
  final List<int> tabNumber = <int>[
    0,
    1,
    2,
    3,
  ];

  String homePageContent = '正在获取数据.....';
  TabController _tabController;
  String url = 'getArticleList';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  bool isShowButton = true;
  // bool showTitle = true;

  _onScroll(offset) {
    double alpha = offset / APPBAE_SCROLL_OFFSET;
    if (alpha == 0) {
      setState(() {
        isShowButton = true;
      });
      // isChangeBar = true;
      print(isShowButton);
    }
    if (alpha > 0 && isShowButton == true) {
      setState(() {
        isShowButton = false;
      });
      // isChangeBar = false;
      print(isShowButton);
    }
    print(alpha);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              //标题居中
              // centerTitle: true,
              //展开高度
              expandedHeight: 85.0,
              floating: true,
              //固定在顶部
              pinned: true,
              snap: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: SearchBarDelegate());
                    })
              ],
              // flexibleSpace: FlexibleSpaceBar(
              //   // centerTitle: true,
              //   title: Text('playMate'),
              // ),
              title: Text('playMate'),

              bottom: TabBar(
                controller: _tabController,
                tabs: tabs,
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: tabNumber.map((int number) {
            return NotificationListener(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
                return false;
              },
              child: SafeArea(
                child: ShowArticleList(
                  url: url,
                  articleTypeId: number,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: isShowButton
          ? FloatingActionButton(
              onPressed: () {
                Application.router.navigateTo(
                  context,
                  '/addArticle',
                  transition: TransitionType.fadeIn,
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

//轮播图控件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 333.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['image']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
