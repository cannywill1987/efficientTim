import 'package:flutter/material.dart';

import '../../models/FolderModel.dart';
import 'MissionPage.dart';

class NewMissionPage extends StatelessWidget {
  final FolderModel? folderModel;
  final int? folderStatusDate;
  final Function? onTapNavMenuListener;
  final Function? onTapRightNavMenuListener;

  const NewMissionPage({
    super.key,
    this.folderModel,
    this.folderStatusDate,
    this.onTapNavMenuListener,
    this.onTapRightNavMenuListener,
  });

  @override
  Widget build(BuildContext context) {
    return MissionPage(
      onTapRightNavMenuListener: onTapRightNavMenuListener,
      onTapNavMenuListener: onTapNavMenuListener,
      folderModel: folderModel,
      folderStatusDate: folderStatusDate,
      useUnifiedStyle: true,
    );
  }
}
