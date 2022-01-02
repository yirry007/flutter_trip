import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';

class SearchPage extends StatefulWidget{
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  String showText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: '嘿嘿',
            hint: '123',
            leftButtonClick: (){
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
            speakClick: () {  },
            inputBoxClick: () {  },
            rightButtonClick: () {  },
          ),
          InkWell(
            onTap: (){
              SearchDao.fetch('https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=长城').then((SearchModel value){
                setState(() {
                  showText = value.data![0].url.toString();
                });
              });
            },
            child: Text('Get'),
          ),
          Text(showText),
        ],
      ),
    );
  }

  _onTextChange(String value){}
}