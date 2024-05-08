import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../common/database/apis/MongoApisManager.dart';
import '../../../config/ColorsConfig.dart';
import '../../../config/ENUMS.dart';
import '../../../models/WQBMissionModel.dart';
import '../../statisticPage/components/TitleContainerWidget.dart';

class WQBMasteringSiturationWidget extends StatefulWidget {
  WQBMissionModel wqbMissionModel;
   SaveModeEnum saveModeEnum;

  WQBMasteringSiturationWidget({required this.wqbMissionModel, required this.saveModeEnum});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WQBMasteringSiturationWidgetState();
  }
}

class WQBMasteringSiturationWidgetState
    extends State<WQBMasteringSiturationWidget> {
  SaveModeEnum editTypeEnum = SaveModeEnum.normal;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisSize: MainAxisSize.max, children: [
      TitleContainerWidget(
          title: getI18NKey().mastering_the_situation,
          rightPartContainer: InkWell(
            onTap: () {
              setState(() {
                if (editTypeEnum == SaveModeEnum.normal) {
                  editTypeEnum = SaveModeEnum.update;
                } else if (editTypeEnum == SaveModeEnum.update) {
                  editTypeEnum = SaveModeEnum.normal;
                }
              });
              // this.widget.onTapEdit.call();
            },
            child: SizedBox.shrink(),
          )),
      Container(
          width: double.infinity,
          height: 2,
          color: ColorsConfig.borderLineColor),
      SizedBox(height: 10,),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(getI18NKey().rusty),
          SizedBox(width: 5,),
          RatingBar.builder(
            initialRating: this.widget.wqbMissionModel.masterScore ?? 1,
            glowColor: Color(0xffff8800),
            minRating: 0,
            itemSize: 25,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            onRatingUpdate: (rating) {
              this.widget.wqbMissionModel?.masterScore = rating;
              if(this.widget.saveModeEnum == SaveModeEnum.normal) {
                MongoApisManager.getInstance().update_WQBMissionModel(missionModel:this.widget.wqbMissionModel);
              }
              setState(() {});
              // setState(() {
              //   _response!.rating = rating;
              //   if(_response!.rating < 5) {
              //     this.isCommentShowed = true;
              //   } else {
              //     this.isCommentShowed = false;
              //   }
              // });
            },
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Color(0xffff8800),
            ),
          ),
          SizedBox(width: 5,),
          Text(getI18NKey().skilled),
        ],
      )
    ]);
  }
}
