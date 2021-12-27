import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/local_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List _imageUrls = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg',
  ];
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  GridNavModel? gridNavModel;

  @override
  void initState(){
    super.initState();
    loadData();
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

  loadData() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        resultString = json.encode(model.config);
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: Stack(
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
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child: Swiper(
                      itemCount: _imageUrls.length,
                      autoplay: true,
                      pagination: SwiperPagination(),
                      itemBuilder: (BuildContext context, int index){
                        return Image.network(_imageUrls[index], fit:BoxFit.fill);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                    child: LocalNav(localNavList: localNavList),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 6, 4),
                    child: GridNav(gridNavModel: gridNavModel),
                  ),
                  // Container(
                  //   height: 800,
                  //   child: ListTile(
                  //     title: Text(resultString),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Opacity(
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
          ),
        ],
      ),
    );
  }
}