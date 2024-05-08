library universal_ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/extensions.dart';
import 'package:time_hello/com/timehello/libs/flutterquill/flutter_quill.dart';
import 'package:universal_html/html.dart' as html;
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../components/responsive_widget.dart';
import '../../../libs/flutterExtension/embeds/utils.dart';
// import 'fake_ui.dart' if (dart.library.html) 'real_ui.dart' as ui_instance;
import 'fake_ui.dart' as ui_instance;
class PlatformViewRegistryFix {
  void registerViewFactory(dynamic x, dynamic y) {
    if (kIsWeb) {
      ui_instance.PlatformViewRegistry.registerViewFactory(
        x,
        y,
      );
    }
  }
}

class UniversalUI {
  PlatformViewRegistryFix platformViewRegistry = PlatformViewRegistryFix();
}

var ui = UniversalUI();

class ImageEmbedBuilderWeb implements EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
      BuildContext context,
      QuillController controller,
      Embed node,
      bool readOnly,
      bool readOnly2,
      TextStyle textStyle,
      ) {
    final imageUrl = node.value.data;
    if (isImageBase64(imageUrl)) {
      // TODO: handle imageUrl of base64
      return const SizedBox();
    }
    final size = MediaQuery.of(context).size;
    UniversalUI().platformViewRegistry.registerViewFactory(
        imageUrl, (viewId) => html.ImageElement()..src = imageUrl);
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveWidget.isMediumScreen(context)
            ? size.width * 0.5
            : (ResponsiveWidget.isLargeScreen(context))
            ? size.width * 0.75
            : size.width * 0.2,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: HtmlElementView(
          viewType: imageUrl,
        ),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    // TODO: implement buildWidgetSpan
    throw UnimplementedError();
  }

  @override
  // TODO: implement expanded
  bool get expanded => throw UnimplementedError();
}

class VideoEmbedBuilderWeb implements EmbedBuilder {
  @override
  String get key => BlockEmbed.videoType;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node,
      bool readOnly, bool a, TextStyle textStyle) {
    var videoUrl = node.value.data;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      // final youtubeID = YoutubePlayer.convertUrlToId(videoUrl);
      // if (youtubeID != null) {
      //   videoUrl = 'https://www.youtube.com/embed/$youtubeID';
      // }
    }

    UniversalUI().platformViewRegistry.registerViewFactory(
        videoUrl,
            (id) => html.IFrameElement()
          ..width = MediaQuery.of(context).size.width.toString()
          ..height = MediaQuery.of(context).size.height.toString()
          ..src = videoUrl
          ..style.border = 'none');

    return SizedBox(
      height: 500,
      child: HtmlElementView(
        viewType: videoUrl,
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    // TODO: implement buildWidgetSpan
    throw UnimplementedError();
  }

  @override
  // TODO: implement expanded
  bool get expanded => throw UnimplementedError();
}

List<EmbedBuilder> get defaultEmbedBuildersWeb => [
  ImageEmbedBuilderWeb(),
  VideoEmbedBuilderWeb(),
];
