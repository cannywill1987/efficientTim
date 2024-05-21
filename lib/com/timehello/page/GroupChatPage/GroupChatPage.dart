import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupAnnouncement.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupChatFriendsList.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupInfoPage.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../models/FolderModel.dart';

class GroupChatPage extends BaseWidget {
  const GroupChatPage({Key? key}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _GroupChatPageState();
  }
}

class _GroupChatPageState extends BaseWidgetState<GroupChatPage> {
  FolderModel? folderModel;

  @override
  Widget baseBuild(BuildContext context) {
    return Selector<Env, FolderModel>(
        selector: (_, globalStateEnv) => globalStateEnv.curFolderSelected,
        builder: (_, folderModel, __) {
          this.folderModel = folderModel;
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                if(this.folderModel != null)
                SliverToBoxAdapter(child: GroupInfoPage(folderModel: this.folderModel!, onTapShare: () {
                  DialogManagement.getInstance().showGroupChatSharingWidgetDialog(folderModel: this.folderModel!);
                },),),
                SliverToBoxAdapter(
                  child: InkWell(
                      onTap: () {
                        DialogManagement.getInstance().showMultiInputDialog(
                            title: "群公告",
                            okCallback: (val) async {
                              if (this.folderModel?.objectId != null &&
                                  val != null &&
                                  val.isNotEmpty) {
                                this.folderModel?.introText = val;
                                await MongoApisManager.getInstance()
                                    ?.update_FolderModelWithFM(
                                        shouldQueryMissionModel: false,
                                        folderModel:
                                            this.folderModel ?? FolderModel());
                                updateUI();
                              } else {
                                Utility.showToast(msg: "内容不能为空");
                              }
                            });
                      },
                      child: GroupAnnouncement()),
                ),
                SliverToBoxAdapter(child: _buildAnnouncement()),
                SliverToBoxAdapter(child: _buildSearch()),
                GroupChatFriendsSliverList(
                  friends: [],
                  onFriendTap: () {},
                  onFriendLongPress: () {},
                  onFriendRemove: () {},
                )
              ],
            ),
          );
        });
  }

  Widget _buildAnnouncement() {
    return

        // Image.network('https://via.placeholder.com/150'), // Replace with your image URL
        // SizedBox(height: 5),
        Container(
      height: 200,
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Text(
          // "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111",
          this.folderModel?.introText ?? "",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
