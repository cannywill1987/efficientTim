import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/models/MusicModel.dart';
import 'package:time_hello/com/timehello/util/AudioPlayUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'CheckImage.dart';
import 'LoadingDialogUtil.dart';

typedef OnMusicTapListener = void Function(MusicModel ob, String sj);

GlobalKey<DialogContentState> SelectMusicDialogUtilStateGlobalKey = GlobalKey();

class SelectMusicDialogUtil {
  static SelectMusicDialogUtil? _instance;
  static SelectMusicDialogUtil getInstance() {
    if(_instance == null) {
      _instance = new SelectMusicDialogUtil();
    }
    return _instance!;
  }

    show(BuildContext mContext,
      {String? title,
        MusicModel? musicModel,
      String? content,
      List<MusicModel>? list,
      OnMusicTapListener? onMusicTapListener,
      }) {
     title = title ?? getI18NKey().remind;
    showDialog(
        context: mContext,
        builder: (BuildContext context) {
          // if (dialogContent == null) {
            return DialogContent(
                key: SelectMusicDialogUtilStateGlobalKey,
                title: title,
              musicModel: musicModel,
                content: content,
                list: list ?? [],
                onMusicTapListener: onMusicTapListener,
                );
          // } else {
          //   return dialogContent;
          // }
        });
  }
}

class DialogContent extends StatefulWidget {
   String? title; //标题
   String? content; //内容
   List<MusicModel>? list;
   OnMusicTapListener? onMusicTapListener;
  MusicModel? musicModel;
  DialogContent(
      {Key? key,
      this.onMusicTapListener,
        this.musicModel,
      this.title,
      this.content,
      this.list,
      })
      : super(key: key);

  @override
  DialogContentState createState() => DialogContentState(
      onMusicTapListener: this.onMusicTapListener,
      title: this.title,
      content: this.content,
      list: this.list,
      );
}

class DialogContentState extends State<DialogContent> {
  String? label = '';
   String? title; //标题
   String? content; //内容
   bool? onlyRight; //右边按钮文字
  List<MusicModel>? list;
   OnMusicTapListener? onMusicTapListener;
  DialogContentState(
      {
      this.onMusicTapListener,
      this.title,
      this.content,
      this.onlyRight,
      this.list,
      });

  @override
  void didUpdateWidget(DialogContent oldWidget) {
    this.requestData();
  }

  void requestData() async {
    List<MusicModel> list =  this.list ?? CONSTANTS.getMusicModelList();
    list.forEach((element) {
      if (element?.title == this.widget.musicModel?.title) {
        element.isChecked = true;
      }
    });
    setState(() {
      this.list = list;
    });
  }


  @override
  void deactivate() {
    super.deactivate();
    AudioPlayUtil.getInstance()?.stop();
  }

  @override
  void initState() {
    super.initState();
    this.requestData();
  }

  void resetList() {
    for (int i = 0;i < (this.list?.length ?? 0); i++) {
      MusicModel m = this.list![i];
      m.isChecked = false;
    }
  }

  getContentView() {
    List<Widget> list = [];
    List<MusicModel> listModels = this.list ?? [];
    for (int i = 0; i < listModels.length; i++) {
      MusicModel data = listModels[i];
      list.add(InkWell(
        onTap: () async {
          LoadingDialogUtil.getInstance().show(context);
          String localPath = await Utility.downloadFileByUrl(Utility.getOSSOriginFromUrl(data.url ?? ""), title: data.title ?? "") ?? "";
          LoadingDialogUtil.getInstance().hide();
          AudioPlayUtil.getInstance()?.play(localPath, volume: 50, shouldForcePlay: true, loopMode: LoopMode.one);
          this.resetList();
          data.localPath = localPath;
          data.isChecked = true;
          if (this.onMusicTapListener != null) {
            this.onMusicTapListener!(data, localPath);
          }
          setState(() {

          });
        },
        child: Container(
            height: 60,
            padding: new EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      data.title ?? '',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                CheckImage(
                  checked: data.isChecked ?? false,
                  checkIcon: Icon(Icons.radio_button_checked_outlined,
                      color: ColorsConfig.gray_a7),
                  uncheckIcon: Icon(Icons.radio_button_unchecked_outlined,
                      color: ColorsConfig.gray_a7),
                ),
              ],
            )),
      ));
    }
    return Column(
      children: list,
    );
  }

  @override
  void didChangeDependencies() {
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      //自定义dialog布局
      child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  color: ThemeManager.getInstance().getDialogBackgroundColor(defaultColor: Colors.white),
                  constraints:
                      BoxConstraints(maxHeight: 500, maxWidth: 500),
                  // color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Text(title ?? "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Text(content ?? "",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400)),
                      Container(
                        height: 200,
                        child: new ListView(children: <Widget>[
                          Container(child: getContentView()),
                        ]),
                      ),
                    ],
                  ))),
        )
      ]),
    );
  }
}
