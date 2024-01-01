import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chat Screen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: appColor.,
        title: Text(widget.title),
      ),
      backgroundColor: appColor.background,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: 100,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final isMyMessage = index % 2 == 0;
                final key = GlobalKey();
                String title = "This is message content, id: $index";
                if (index % 10 == 0) {
                  title = "This is message content, id: $index\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content\n"
                      "This is message content";
                }
                return Align(
                  alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    onLongPress: () {
                      Get.to(
                        () => MessageActions(
                          title: title,
                          isMyMessage: isMyMessage,
                          heroTag: "message$index",
                          parentKey: key,
                        ),
                        fullscreenDialog: true,
                        transition: Transition.fadeIn,
                        opaque: false,
                      );
                      // showDialog(
                      //   context: context,
                      //   useSafeArea: false,
                      //   builder: (BuildContext context) => MessageActions(
                      //     title: title,
                      //     isMyMessage: isMyMessage,
                      //     heroTag: "message$index",
                      //     parentKey: key,
                      //   ),
                      // );
                    },
                    child: Hero(
                      tag: "message$index",
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          key: key,
                          margin: EdgeInsets.only(left: isMyMessage ? 100 : 0, right: isMyMessage ? 0 : 100),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isMyMessage ? appColor.secondaryContainer : appColor.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(title),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageActions extends StatelessWidget {
  const MessageActions(
      {super.key, required this.title, required this.isMyMessage, required this.heroTag, required this.parentKey});

  final String title;
  final String heroTag;
  final bool isMyMessage;
  final GlobalKey parentKey;

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    final box = parentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      Get.back();
      return const SizedBox();
    }

    final size = box.size;
    final offset = box.localToGlobal(Offset.zero);
    Offset newOffset;
    if (size.height + offset.dy + 100 + context.mediaQueryPadding.bottom > context.height) {
      newOffset = Offset(
        offset.dx,
        context.height - (size.height + 100 + context.mediaQueryPadding.bottom),
      );
    } else {
      newOffset = offset;
    }
    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification) {
        Get.back();
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: GestureDetector(
          onTap: () => Get.back(),
          child: CupertinoPageScaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  left: isMyMessage ? null : offset.dx,
                  right: isMyMessage ? 16 : null,
                  top: newOffset.dy + size.height + 8,
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Đã sao chép."),
                            // behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                "Sao chép tin nhắn",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // style: AppTextStyle.bodyLarge?.copyWith(height: 1.25, color: AppColor.textLow),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.copy, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: newOffset.dy,
                  left: newOffset.dx,
                  width: size.width,
                  child: Hero(
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        key: key,
                        margin: EdgeInsets.only(left: isMyMessage ? 100 : 0, right: isMyMessage ? 0 : 100),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMyMessage ? appColor.secondaryContainer : appColor.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(title),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
