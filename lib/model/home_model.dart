import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

class HomeModel{
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final GridNavModel gridNav;
  final List<CommonModel> subNavList;
  final SalesBoxModel salesBox;

  HomeModel({
    required this.config,
    required this.bannerList,
    required this.localNavList,
    required this.gridNav,
    required this.subNavList,
    required this.salesBox,
  });

  factory HomeModel.fromJson(Map<String, dynamic>json){
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map((v)=>CommonModel.fromJson(v)).toList();

    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson.map((v)=>CommonModel.fromJson(v)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList = subNavListJson.map((v)=>CommonModel.fromJson(v)).toList();

    return HomeModel(
      localNavList: localNavList,
      bannerList: bannerList,
      subNavList: subNavList,
      config: ConfigModel.fromJson(json['config']),
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['localNavList'] = this.localNavList;
    data['bannerList'] = this.bannerList;
    data['subNavList'] = this.subNavList;
    data['config'] = this.config;
    data['gridNav'] = this.gridNav;
    data['salesBox'] = this.salesBox;
    return data;
  }
}