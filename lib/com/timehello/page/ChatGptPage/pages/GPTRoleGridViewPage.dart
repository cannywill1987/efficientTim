import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/beans/ResourceDeliveryInfoBean.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/common/provider/Env.dart';
import 'package:time_hello/com/timehello/components/BaseWidget.dart';
import 'package:time_hello/com/timehello/components/SearchBarWidget.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/libs/mongodb/response/MongoDbSaved.dart';
import 'package:time_hello/com/timehello/models/ChatGptFolderModel.dart';
import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';

import '../../../models/ChatGptMessageModel.dart';

class GPTRoleGridViewPage extends BaseWidget {
  Function onClickCreated;
  GPTRoleGridViewPage({Key? key, required this.onClickCreated}) : super(key: key);

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return GPTRoleGridViewPageState();
  }
}

class GPTRoleGridViewPageState extends BaseWidgetState<GPTRoleGridViewPage> {
  String searchText = "";
  late List<ResourceDeliveryInfoBean> deliveryList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveryList = ResourceInfo.promptsGptResourceLocationInfoBean?.deliveryList ?? [];
  }

  requestDatas(String text) {
    // text = "女友";
    List<ResourceDeliveryInfoBean> deliveryListParams = ResourceInfo.promptsGptResourceLocationInfoBean?.deliveryList ?? [];
    if (text.isNotEmpty) {
      deliveryList = deliveryListParams.where((element) => element.resourceTitle?.contains(text) ?? false).toList();
    } else {
      deliveryList = deliveryListParams;
    }
    updateUI();
  }

  @override
  baseBuild(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(height: 30, margin: EdgeInsets.symmetric(vertical: 10),child: SearchBarWidget(onChangeListener: (text) {
            requestDatas(text);
            // setState(() {
            //   searchText = text;
            // });
          }),),
          Expanded(
            child: CustomScrollView(
              slivers: [SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  // crossAxisCount: 2,
                  maxCrossAxisExtent: 200, // 固定宽度
                  childAspectRatio: 2.5, // 宽高比
                  mainAxisSpacing: 10.0, // 主轴间距
                  crossAxisSpacing: 10.0, // 横轴间距
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        ResourceDeliveryInfoBean? item  = deliveryList?[index];
                        // return Text("123", style: TextStyle(color: Color(0xffff8800)),);
                    return GestureDetector(
                      onTap: () {
                        DialogManagement.getInstance().showGPTInputDialog(title: item?.resourceTitle ?? "", content: item?.resourceContent ?? "",okCallback: (text) async {
                          ChatGptFolderModel chatGptFolderModel = ChatGptFolderModel();
                          chatGptFolderModel.title = text;
                          MongoDbSaved? res = await MongoApisManager.getInstance().insertChatGptFolderModel(chatGptFolderModel: chatGptFolderModel);
                          ChatGptMessageModel chatGptMessageModel = ChatGptMessageModel();
                          chatGptMessageModel.text = text;
                          chatGptMessageModel.folderTitle = text;
                          chatGptMessageModel.countryCode = DeviceInfoManagement.getCountryCode();
                          chatGptMessageModel.fid = res?.objectId;
                          chatGptMessageModel.avatar = LoginManager.getInstance().userBean.avatar;
                          chatGptMessageModel.username = LoginManager.getInstance().userBean.username;
                          await MongoApisManager.getInstance()
                              .insertChatGptMessageModel(chatGptMessageModel: chatGptMessageModel);
                          context.read<Env>().curChatGptFolderModel = chatGptFolderModel;
                          widget.onClickCreated(text);
                          // item?.resourceTitle = text;
                          // updateUI();
                        });
                      },
                      child: GPTRoleGridViewItem(
                        bean: item,
                      ),
                    );
                  },
                  childCount: deliveryList.length,
                ),
              )],
            ),
          ),
        ],
      ),
    );
  }
}

//外border 1 色值 #F5F5F5 圆角 container
//内部 是个可换行的text 超出3行用ellipsis
class GPTRoleGridViewItem extends StatelessWidget {
  ResourceDeliveryInfoBean? bean;
  GPTRoleGridViewItem({required this.bean});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ThemeManager.getInstance().getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          bean?.resourceTitle ?? "",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
        ),
      );
    });
  }

}