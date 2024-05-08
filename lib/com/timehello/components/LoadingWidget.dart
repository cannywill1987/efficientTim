import 'package:flutter/cupertino.dart';
import 'package:time_hello/r.dart';

class LoadingWidget extends StatefulWidget {
  double size = 50;

  LoadingWidget({this.size = 50});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoadingWidgetState();
  }
}

class LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    this.startAnim();
  }

  @override
  void dispose() {
    isDisposed = true;
    this.removeListeners();
    super.dispose();
  }

  startAnim() {
    isDisposed = false;
    animationController = new AnimationController(
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 400),
        vsync: this);
    animation = new Tween(begin: 0.0, end: this.widget.size).animate(animationController!)
      ..addListener(() {
        if (this.isDisposed == false)
          setState(() {
            // the state that has changed here is the animation object’s value
          });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController?.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController?.forward();
        }
      });
    animationController!.forward();
  }

  void removeListeners() {
    animationController?.dispose();
    // animationController?.removeListener(null);
    // animation?.removeListener(null);
    animation = null;
    animationController = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Image.asset(
      R.assetsImgIcTomatoWhite2,
      fit: BoxFit.fill,
      width: animation != null ? animation!.value : this.widget.size,
      height: this.widget.size,
    );
  }
}
