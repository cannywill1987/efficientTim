import 'package:flutter/material.dart';

import '../../interface/OnCallbackListener.dart';
import 'FoldersPage.dart';

class NewFolderPage extends StatelessWidget {
  final OnMapCallback onTapListener;

  const NewFolderPage({super.key, required this.onTapListener});

  @override
  Widget build(BuildContext context) {
    return FoldersPage(
      onTapListener: onTapListener,
      useUnifiedStyle: true,
    );
  }
}
