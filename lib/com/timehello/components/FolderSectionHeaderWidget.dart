import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:time_hello/com/timehello/components/CustomPopupWidget.dart';
import 'package:time_hello/com/timehello/components/CustomTextField.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../util/DeviceInfoManagement.dart';
import '../util/LoginManager.dart';

class FolderSectionHeaderWidget extends StatefulWidget {
  final String title;
  bool isEditing = false;
  bool isArchived = false;
  bool isFoldedForFolder = false;
  double marginTop = 0;
  double marginBottom = 0;
  final Function(String) onEnterListener;
  Function()? onCancelListener;
  Function()? onArchiveListener;
  Function()? onUnarchiveListener;
  Function(bool)? onTapFoldedListener;
  Function()? onDeleteListener;
  Function()? onCreateMissionFolderListener;

  FolderSectionHeaderWidget(
      {Key? key,
      required this.onEnterListener,
      this.isArchived = false,
        required this.onTapFoldedListener,
      required this.onCreateMissionFolderListener,
      required this.onArchiveListener,
      required this.onUnarchiveListener,
        required this.isFoldedForFolder,
      required this.onDeleteListener,
      this.marginBottom = 0,
      this.marginTop = 0,
      required this.onCancelListener,
      required this.title,
      this.isEditing = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FolderSectionHeaderWidgetState(isFoldedForFolder: this.isFoldedForFolder);
  }
}

class FolderSectionHeaderWidgetState extends State<FolderSectionHeaderWidget> {
  bool isHover = false;
  bool isFoldedForFolder = false;
  double ratio = Utility.getRatioForSlider(
    numItem: 5,
  );
  FolderSectionHeaderWidgetState({bool isFoldedForFolder = false}) {
    this.isFoldedForFolder = isFoldedForFolder;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.isFoldedForFolder = this.widget.isFoldedForFolder;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if ((DeviceInfoManagement.isMoible() == true ||
        DeviceInfoManagement.isWebMobileBySize())) {
      return Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: ratio,
          children: getSlideActions(),
        ),
        child: getItem(),
      );
    } else {
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            this.isHover = true;
          });
        },
        onHover: (_) {},
        onExit: (_) {
          setState(() {
            this.isHover = false;
          });
        },
        child: getItem(),
      );

    }
  }

  List<Widget> getSlideActions() {
    //只有自己可以对课程编辑删除
    // !TextUtil.isEmpty(_folderModelWithExtraData.folderModel.courseModelId) &&
    return <Widget>[
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onCreateMissionFolderListener != null) {
            this.widget.onCreateMissionFolderListener!(); // 侧边栏编辑
          }
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        icon: Icons.add,
        // label: getI18NKey().edit,
      ),
        SlidableAction(
          onPressed: (context) {
            if (this.widget.onArchiveListener != null) {
              this.widget.onArchiveListener?.call(); // 侧边栏编辑
            }
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.archive, // 自定义图标
          // label: getI18NKey().unarchive,
        ),
      SlidableAction(
        onPressed: (context) {
          if (this.widget.onDeleteListener != null) {
            this.widget.onDeleteListener!(); // 侧边栏删除
          }
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        icon: Icons.delete,
        // label: getI18NKey().delete,
      ),
    ];
  }

  InkWell getItem() {
    return InkWell(
      onTap: () {
        if(this.isFoldedForFolder == false) {
          this.isFoldedForFolder = true;
        } else {
          this.isFoldedForFolder = false;
        }
        this.widget.onTapFoldedListener?.call(this.isFoldedForFolder);
        setState(() {

        });
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  top: 2, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Utility.getSVGPicture(R.assetsImgIcFolder, size: 20),
                  SizedBox(
                    width: 6,
                  ),
                  CustomTextField(
                    isEditing: this.widget.isEditing,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.getInstance().isDark() ? Colors.white : Colors.black),
                    text: this.widget.title,
                    onCancelListener: () {
                      this.widget.onCancelListener?.call();
                    },
                    onEnterListener: (data) {
                      this.widget.onEnterListener.call(data);
                    },
                  )
                ],
              ),
            ),
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              (this.isHover == true)
                  ? Container(
                      // color: Colors.red,
                      width: 30,
                      height: 30,
                      child: CustomPopupWidget(
                        onSelected: (val) async {
                          switch (val.code) {
                            case "archive":
                              if (this.widget.isArchived) {
                                this.widget.onUnarchiveListener?.call();
                              } else {
                                this.widget.onArchiveListener?.call();
                              }
                              break;
                            case "unarchive":
                              this.widget.onUnarchiveListener?.call();
                              break;
                            case "delete":
                              this.widget.onDeleteListener?.call();
                              break;
                          }
                          // updateUI();
                        },
                        list: CONSTANTS.getFolderModelCheckButtonStateModel(
                            isArchived: this.widget.isArchived),
                        child: Icon(
                          Icons.more_horiz,
                          color: ThemeManager.getInstance()
                              .getIconColor(defaultColor: Color(0xff909090)),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              //白色正方形+好 inkwell可点击
              if (this.widget.isArchived == false)
                InkWell(
                  onTap: () {
                    this.widget.onCreateMissionFolderListener?.call();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: ThemeManager.getInstance().getIconColor(
                        defaultColor: Color(0xff909090),
                      ),
                      size: 20,
                    ),
                  ),
                ),
              // if(this.isFoldedForFolder == false)
                InkWell(
                  onTap: () {
                    if(this.isFoldedForFolder == false) {
                      this.isFoldedForFolder = true;
                    } else {
                      this.isFoldedForFolder = false;
                    }
                    this.widget.onTapFoldedListener?.call(this.isFoldedForFolder);
                    setState(() {

                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    child: Icon(
                      this.isFoldedForFolder == true ?  Icons.unfold_more : Icons.unfold_less,
                      color: ThemeManager.getInstance().getIconColor(
                        defaultColor: Color(0xff909090),
                      ),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
            ],
          )
        ],
      ),
    );
  }
}
