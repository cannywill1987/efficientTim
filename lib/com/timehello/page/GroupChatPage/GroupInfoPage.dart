import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupAnnouncement.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupChatFriendsList.dart';
import 'package:time_hello/com/timehello/page/GroupChatPage/components/GroupInfoPage.dart';
import 'package:time_hello/com/timehello/util/ChatGptManager.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../beans/UserInfoBean.dart';
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
  String? curSearchWords = null;

  @override
  Widget baseBuild(BuildContext context) {
    return Selector<Env, FolderModel>(
        selector: (_, globalStateEnv) => globalStateEnv.curFolderSelected,
        builder: (_, folderModel, __) {
          this.folderModel = folderModel;
          return CustomScrollView(
            slivers: [
              if (this.folderModel != null)
                SliverToBoxAdapter(
                  child: GroupInfoWidget(
                    folderModel: this.folderModel!,
                    onTapShare: () {
                      DialogManagement.getInstance()
                          .showGroupChatSharingWidgetDialog(
                              folderModel: this.folderModel!);
                    },
                    onTapQuit: () {
                      ChatGroupManager.exitGroup(folderModel: this.folderModel);
                      Utility.popupDesktopRightNavigator(context);
                      // DialogManagement.getInstance().showAlertDialog(
                      //     title: "退出群聊",
                      //     content: "确定要退出群聊吗？",
                      //     okCallback: () async {
                      //       await MongoApisManager.getInstance()
                      //           ?.quitGroupChat(folderModel: this.folderModel!);
                      //       Navigator.pop(context);
                      //     });
                      // }
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: Color(0xffe0e0e0),
                ),
              ),
              SliverToBoxAdapter(
                child: InkWell(
                    onTap: () {
                      DialogManagement.getInstance().showMultiInputDialog(
                          title: getI18NKey().group_announcement,
                          okCallback: (val) async {
                            if (ChatGroupManager.isFolderModelEnabled(
                                folderId: this.folderModel?.objectId)) {
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
                                Utility.showToastMsg(
                                    msg: getI18NKey().content_cannot_be_empty);
                              }
                            }
                          });
                    },
                    child: GroupAnnouncement(
                      folderModel: this.folderModel,
                    )),
              ),
              SliverToBoxAdapter(child: _buildAnnouncement()),
              SliverToBoxAdapter(
                child: Container(
                  height: 1,
                  color: Color(0xffe0e0e0),
                ),
              ),
              SliverToBoxAdapter(child: _buildSearch()),
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 1,
                  color: Color(0xffe0e0e0),
                ),
              ),
              GroupChatFriendsSliverList(
                folderModel: this.folderModel ?? FolderModel(),
                userInfoBeans: getUserInfoBean(),
                onFriendTap: () {},
                userInfoBeanCreator:
                    this.folderModel?.userInfoBean ?? UserInfoBean(),
                onTapCancelAdministrator: (folderModel) {
                  this.folderModel = folderModel;
                  updateUI();
                },
                onTapSetAdministrator: (folderModel) {
                  this.folderModel = folderModel;
                  updateUI();
                },
                onTapDeleteUser: (folderModel) {
                  this.folderModel = folderModel;
                  updateUI();
                },
              )
            ],
          );
        });
  }

  List<dynamic> getUserInfoBean() {
    if (this.curSearchWords != null && this.curSearchWords!.isNotEmpty) {
      return this
              .folderModel
              ?.otherUserInfoBean
              ?.where((element) => (element.username ?? "")
                  .toLowerCase()
                  .contains(this.curSearchWords!.toLowerCase()))
              .toList() ??
          [];
    }
    return this.folderModel?.otherUserInfoBean ?? [];
  }

  Widget _buildAnnouncement() {
    return

        // Image.network('https://via.placeholder.com/150'), // Replace with your image URL
        // SizedBox(height: 5),
        Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      // color: Colors.white,
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
      child: Container(
        alignment: Alignment.center,
        height: 32,
        child: TextField(
          onChanged: (val) {
            this.curSearchWords = val;
            updateUI();
          },
          // st
          decoration: InputDecoration(
            hintText: getI18NKey().search,
            hintStyle: TextStyle(
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
