import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';

enum SearchBarType {home, normal, homeLight}
class SearchBar extends StatefulWidget{
  final bool enabled;
  final bool? hideLeft;
  final SearchBarType searchBarType;
  final String? hint;
  final String? defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({Key? key, this.enabled = true, this.hideLeft, this.searchBarType = SearchBarType.normal, this.hint, this.defaultText, required this.leftButtonClick, required this.rightButtonClick, required this.speakClick, required this.inputBoxClick, required this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>{
  bool showClear = false;
  //动态获取输入框文字的变化
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText.toString();
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal ? _genNormalSearch() : _genHomeSearch();
  }

  _genNormalSearch(){
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft??false ? null : Icon(Icons.arrow_back_ios, color: Colors.grey, size: 26),
            ),
            widget.leftButtonClick
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text('搜索', style: TextStyle(color: Colors.blue, fontSize: 17)),
              ),
              widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  _genHomeSearch(){
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '上海',
                      style: TextStyle(color: _homeFontColor(), fontSize: 14),
                    ),
                    Icon(Icons.expand_more, color: _homeFontColor(), size: 22),
                  ],
                ),
              ),
              widget.leftButtonClick
          ),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Icon(Icons.comment, color: _homeFontColor(), size: 26),
            ),
            widget.rightButtonClick,
          ),
        ],
      ),
    );
  }

  _inputBox(){
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }

    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
          widget.searchBarType == SearchBarType.normal ? 5 : 15
        )
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9) : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
              ? TextField(
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(fontSize: 13),
                ),
              )
              : _wrapTap(
                Container(
                  child: Text(widget.defaultText.toString(), style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
                widget.inputBoxClick,
              ),
          ),
          !showClear
            ? _wrapTap(Icon(Icons.mic, size: 22, color: widget.searchBarType == SearchBarType.normal ? Colors.blue : Colors.grey), widget.speakClick)
            : _wrapTap(Icon(Icons.clear, size: 22, color: Colors.grey), () {
              setState(() {
                _controller.clear();
              });
              _onChanged('');
          })
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback){
    return GestureDetector(
      onTap: (){
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _onChanged(String text){
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor(){
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
