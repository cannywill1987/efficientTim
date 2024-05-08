import 'package:flutter/cupertino.dart';

class GameRankingNumWidget extends StatefulWidget {
  Widget icon;
  String val;
  Color color;

  GameRankingNumWidget({required this.icon, required this.val, required this.color});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GameRankingNumWidgetState();
  }
}

class GameRankingNumWidgetState extends State<GameRankingNumWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this.widget.icon,
        SizedBox(width: 5,),
        Text(this.widget.val, style: TextStyle(fontSize: 14, color: this.widget.color),)
      ],
    );
  }

}