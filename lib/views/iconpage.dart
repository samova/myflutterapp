import 'package:flutter/material.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/emojiicon.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class IconPage extends StatefulWidget {
  const IconPage({super.key});

  @override
  State<IconPage> createState() => _IconPageState();
}

class _IconPageState extends State<IconPage> {
  List<EmojiIcon> emojiIcons = [];
  final TextEditingController textController = TextEditingController();
  Set<EmojiIcon> selectedIcons = {};
  bool _emojiShowing = false;
  
  @override
  Widget build(BuildContext context) {
    final appNotifier = context.watch<AppNotifier>();
    emojiIcons = appNotifier.emojiicons;

    return Scaffold(
      appBar: AppBar(title: Text('IconPage')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: emojiIcons.length,
        itemBuilder: (context, index) {
          final icon = emojiIcons[index];
          final isSelected = selectedIcons.contains(icon);
          return GridTile(
            header: Icon(Icons.check_circle, color: isSelected ? Colors.green : Colors.amber),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedIcons.remove(icon);
                  } else {
                    selectedIcons.add(icon);
                  }
                });
              },
              child: Center(
                child: Text(
                  icon.icon,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _emojiShowing = !_emojiShowing;
                  });
                },
                icon: const Icon(Icons.emoji_emotions),
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: 'Enter An Emoji',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{2B50}\u{2B55}\u{2934}\u{2935}\u{2B05}-\u{2B07}\u{2B1B}\u{2B1C}\u{2B50}\u{2B55}]', unicode: true)),
                  ],
                ),
              ),
              SizedBox(width: 20),
              TextButton(
                child: Text('ADD'),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    final newIcon = EmojiIcon(icon: textController.text);
                    appNotifier.addEmojiIcon(newIcon);
                    textController.clear();
                  }
                },
              ),
              SizedBox(width: 20),
              TextButton(
                child: Text('DELETE'),
                onPressed: () {
                  if (selectedIcons.isNotEmpty) {
                    appNotifier.deleteEmojiIcons(selectedIcons.toList());
                    setState(() {
                      selectedIcons.clear();
                    });
                  }
                },
              ),
            ],
          ),
          Offstage(
            offstage: !_emojiShowing,
            child: EmojiPicker(
              textEditingController: textController,
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  emojiSizeMax: 28 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
                ),
                skinToneConfig: const SkinToneConfig(),
                categoryViewConfig: const CategoryViewConfig(),
                bottomActionBarConfig: const BottomActionBarConfig(),
                searchViewConfig: const SearchViewConfig(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

