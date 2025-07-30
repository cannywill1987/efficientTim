import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';

class IsNoteWidget extends StatelessWidget {
  MissionModel missionModel;
  double fontSize = 15;
  Color color = Color(0xffa0a0a0);
  IsNoteWidget({required this.missionModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(TextUtil.isEmpty(missionModel.newRichEditorUrl) && (missionModel.noteRecordUrls?.length ?? 0) == 0 && (missionModel.noteRecordUrls?.length ?? 0) == 0) {
      return SizedBox.shrink();
    }
    return Row(
      children: <Widget>[
        if(!TextUtil.isEmpty(missionModel.newRichEditorUrl))
        Icon(Icons.note_alt, color: color, size: fontSize,), // 文本图标
        if(!TextUtil.isEmpty(missionModel.newRichEditorUrl))
        SizedBox(width: 10),
        if((missionModel.noteRecordUrls?.length ?? 0) > 0)
          Icon(Icons.record_voice_over, color: color, size: fontSize,), // 附件图标
        if((missionModel.noteRecordUrls?.length ?? 0) > 0)
          SizedBox(width: 10),

        if((missionModel.noteRecordUrls?.length ?? 0) > 0)
        Icon(Icons.attach_file, color: color, size: fontSize,), // 附件图标
        if((missionModel.noteRecordUrls?.length ?? 0) > 0)
        SizedBox(width: 10),
      ],
    );
  }

}