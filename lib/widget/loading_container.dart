import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget{
  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({Key? key, required this.isLoading, this.cover=false, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var loadingView;
    if (isLoading) {
      loadingView = _loadingView;
    } else {
      loadingView = null;
    }

    return !cover ?
      (!isLoading ? child : _loadingView) : Stack(
      children: <Widget>[
        child,
        loadingView,
        //_loadingView,
      ],
    );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),//圆形的进度条
    );
  }
}