// import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
// import 'package:flutter/material.dart';
//
// class Test3Page extends StatefulWidget {
//   const Test3Page({Key? key}) : super(key: key);
//
//   @override
//   State createState() => _Test3Page();
// }
//
// class InnerList {
//   final String name;
//   List<String> children;
//   InnerList({required this.name, required this.children});
// }
//
// class _Test3Page extends State<Test3Page> {
//   late List<InnerList> _lists;
//   late List<DragAndDropList> _contents;
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     _lists = List.generate(9, (outerIndex) {
//       return InnerList(
//         name: outerIndex.toString(),
//         children: List.generate(12, (innerIndex) => '$outerIndex.$innerIndex'),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Horizontal'),
//       ),
//       // drawer: const NavigationDrawer(),
//       body: DragAndDropLists(
//         children: List.generate(_lists.length, (index) => _buildList(index)),
//         onItemReorder: _onItemReorder,
//         onListReorder: _onListReorder,
//         axis: Axis.horizontal,
//         listWidth: 150,
//         listDraggingWidth: 150,
//         listDecoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: const BorderRadius.all(Radius.circular(7.0)),
//           boxShadow: const <BoxShadow>[
//             BoxShadow(
//               color: Colors.black45,
//               spreadRadius: 3.0,
//               blurRadius: 6.0,
//               offset: Offset(2, 3),
//             ),
//           ],
//         ),
//         listPadding: const EdgeInsets.all(8.0),
//       ),
//     );
//   }
//
//
//
//   _buildList(int outerIndex) {
//     _contents = List.generate(4, (index) {
//       return DragAndDropList(
//         header: Column(
//           children: <Widget>[
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8, bottom: 4),
//                   child: Text(
//                     'Header $index',
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         children: <DragAndDropItem>[
//           DragAndDropItem(
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   child: Text(
//                     'Sub $index.1',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           DragAndDropItem(
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   child: Text(
//                     'Sub $index.2',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           DragAndDropItem(
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                   child: Text(
//                     'Sub $index.3',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       );
//     });
//
//     return DragAndDropLists(
//       children: _contents,
//       onItemReorder: _onItemReorder,
//       onListReorder: _onListReorder,
//       listPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       itemDivider: Divider(
//         thickness: 2,
//         height: 2,
//         // color: backgroundColor,
//       ),
//       itemDecorationWhileDragging: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 3,
//             offset: const Offset(0, 0), // changes position of shadow
//           ),
//         ],
//       ),
//       listInnerDecoration: BoxDecoration(
//         color: Theme.of(context).canvasColor,
//         borderRadius: const BorderRadius.all(Radius.circular(8.0)),
//       ),
//       lastItemTargetHeight: 8,
//       addLastItemTargetHeightToTop: true,
//       lastListTargetSize: 40,
//       listDragHandle: const DragHandle(
//         verticalAlignment: DragHandleVerticalAlignment.top,
//         child: Padding(
//           padding: EdgeInsets.only(right: 10),
//           child: Icon(
//             Icons.menu,
//             color: Colors.black26,
//           ),
//         ),
//       ),
//       itemDragHandle: const DragHandle(
//         child: Padding(
//           padding: EdgeInsets.only(right: 10),
//           child: Icon(
//             Icons.menu,
//             color: Colors.blueGrey,
//           ),
//         ),
//       ),
//     );
//
//
//     var innerList = _lists[outerIndex];
//     return DragAndDropList(
//       header: Row(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
//                 color: Colors.pink,
//               ),
//               padding: const EdgeInsets.all(10),
//               child: Text(
//                 'Header ${innerList.name}',
//                 style: Theme.of(context).primaryTextTheme.headline6,
//               ),
//             ),
//           ),
//         ],
//       ),
//       footer: Row(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(7.0)),
//                 color: Colors.pink,
//               ),
//               padding: const EdgeInsets.all(10),
//               child: Text(
//                 'Footer ${innerList.name}',
//                 style: Theme.of(context).primaryTextTheme.headline6,
//               ),
//             ),
//           ),
//         ],
//       ),
//       leftSide: const VerticalDivider(
//         color: Colors.pink,
//         width: 1.5,
//         thickness: 1.5,
//       ),
//       rightSide: const VerticalDivider(
//         color: Colors.pink,
//         width: 1.5,
//         thickness: 1.5,
//       ),
//       children: List.generate(innerList.children.length,
//           (index) => _buildItem(innerList.children[index])),
//     );
//   }
//
//   _buildItem(String item) {
//     return DragAndDropItem(
//       child: ListTile(
//         title: Text(item),
//       ),
//     );
//   }
//
//   _onItemReorder(
//       int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
//     setState(() {
//       var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
//       _lists[newListIndex].children.insert(newItemIndex, movedItem);
//     });
//   }
//
//   _onListReorder(int oldListIndex, int newListIndex) {
//     setState(() {
//       var movedList = _lists.removeAt(oldListIndex);
//       _lists.insert(newListIndex, movedList);
//     });
//   }
// }
