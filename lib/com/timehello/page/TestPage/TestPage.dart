// import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/components/CustomBackgroundWidget.dart';
import 'package:time_hello/com/timehello/models/TimelineMissionModel.dart';
import 'package:time_hello/com/timehello/models/WQBMissionModel.dart';

import '../../components/CustomLgLeftChatWidget.dart';
import '../TimeLinePage/components/FileMessageWidget.dart';
import '../WrongQuestionBookPage/components/WQBNoteWidget.dart';
import '../missionPage/componnents/MissionGridView.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestPageState();
  }
}

class TestPageState extends State<TestPage> {
  // AppFlowyEditor? editor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final editorState =
    //     EditorState.blank(withInitialText: true); // with an empty paragraph
    // editor = AppFlowyEditor(
    //   editorState: editorState,
    // );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DraggableHorizontalList();
    // return Row(
    //   children: List.generate(3, (index) => Expanded(child: DraggableList())),
    // );
  }
}

class DraggableHorizontalList extends StatefulWidget {
  @override
  _DraggableHorizontalListState createState() => _DraggableHorizontalListState();
}

class _DraggableHorizontalListState extends State<DraggableHorizontalList> {
  final List<String> items = List.generate(15, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      scrollDirection: Axis.horizontal,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final String item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: items.map((item) => _buildListItem(context, item)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, String item) {
    return Container(
      key: Key(item),
      width: 200,
      child: Card(
        child: Center(child: DraggableList()),
      ),
    );
  }
}

class DraggableList extends StatefulWidget {
  @override
  _DraggableListState createState() => _DraggableListState();
}

class _DraggableListState extends State<DraggableList> {
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final String item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: items.map((item) => _buildListItem(context, item)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, String item) {
    return ListTile(
      key: Key(item),
      title: Draggable<String>(
        data: item,
        child: Text(item),
        feedback: Material(
          child: Text(item),
          elevation: 4.0,
        ),
      ),
    );
  }
}

// class DragTargetList extends StatefulWidget {
//   @override
//   _DragTargetListState createState() => _DragTargetListState();
// }

// class _DragTargetListState extends State<DragTargetList> {
//   final List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];

//   Widget _buildListItem(BuildContext context, String item) {
//     return ListTile(
//       key: Key(item),
//       title: Draggable<String>(
//         data: item,
//         child: Text(item),
//         feedback: Material(
//           child: Text(item),
//           elevation: 4.0,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DragTarget<String>(
//       builder: (context, candidateData, rejectedData) {
//         return ReorderableListView(
//           onReorder: (oldIndex, newIndex) {
//             setState(() {
//               if (newIndex > oldIndex) {
//                 newIndex -= 1;
//               }
//               final String item = items.removeAt(oldIndex);
//               items.insert(newIndex, item);
//             });
//           },
//           children: <Widget>[
//             Container(
//               key: Key('header'),
//               height: 30.0,
//               color: Colors.red,
//               child: Draggable(
//                 data: 'header',
//                 child: Container(
//                   color: Colors.red,
//                   height: 30.0,
//                 ),
//                 feedback: Material(
//                   color: Colors.red,
//                   child: Container(
//                     height: 30.0,
//                   ),
//                   elevation: 4.0,
//                 ),
//               ),
//             ),
//             ...items.map((item) => _buildListItem(context, item)).toList(),
//           ],
//         );
//       },
//       onWillAccept: (data) {
//         return true;
//       },
//       onAccept: (data) {
//         setState(() {
//           items.add(data);
//         });
//       },
//     );
//   }
// }

// class DragTargetList extends StatefulWidget {
//   @override
//   _DragTargetListState createState() => _DragTargetListState();
// }
//
// class _DragTargetListState extends State<DragTargetList> {
//   final List<List<String>> items = [
//     ['Item 1', 'Item 2', 'Item 3', 'Item 4'],
//     ['Item 5', 'Item 6', 'Item 7', 'Item 8'],
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return Draggable<int>(
//           data: index,
//           child: Container(
//             width: 200,
//             child: CustomScrollView(
//               slivers: [
//                 SliverAppBar(
//                   pinned: true,
//                   expandedHeight: 50.0,
//                   flexibleSpace: const FlexibleSpaceBar(
//                     title: Text('Drag me'),
//                   ),
//                 ),
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                         (BuildContext context, int i) {
//                       return ListTile(title: Text(items[index][i]));
//                     },
//                     childCount: items[index].length,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           feedback: Material(
//             child: Container(
//               width: 200,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     pinned: true,
//                     expandedHeight: 50.0,
//                     flexibleSpace: const FlexibleSpaceBar(
//                       title: Text('Drag me'),
//                     ),
//                   ),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                           (BuildContext context, int i) {
//                         return ListTile(title: Text(items[index][i]));
//                       },
//                       childCount: items[index].length,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             elevation: 4.0,
//           ),
//         );
//       },
//     );
//   }
// }