import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/webview.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  GridNavModel? gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel? salesBox;
  bool _loading = true;

  @override
  void initState(){
    super.initState();
    _handleRefresh();
  }

  _onScroll(offset){
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }

    setState(() {
      appBarAlpha = alpha;
    });
    print(alpha);
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model.config);
        bannerList = model.bannerList;
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBox = model.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(//删除手机默认安全边距
              context: context,
              removeTop: true,
              child: NotificationListener(//监听列表组件的滚动
                onNotification: (scrollNotification){
                  if (
                  scrollNotification is ScrollUpdateNotification//滚动有变化时
                      && scrollNotification.depth == 0//子元素的第一层，也就是ListView
                  ) {
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                  return true;
                },
                child: _listView,
              ),
            ),
            _appBar,
          ],
        ),
      ),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
          child: GridNav(gridNavModel: gridNavModel),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
          child: SubNav(subNavList: subNavList),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
          child: SalesBox(salesBox: salesBox),
        ),
      ],
    );
  }

  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

  Widget get _banner {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context)=>WebView(url: bannerList[index].url),
              ));
            },
            child: Image.network(bannerList[index].icon, fit:BoxFit.fill),
          );
        },
      ),
    );
  }
}