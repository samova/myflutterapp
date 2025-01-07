class EmojiIcon {
  String icon;

  EmojiIcon({required this.icon});

  Map<String, dynamic> toMap() {
    return {
      'icon': icon
    };
  }

  factory EmojiIcon.fromMap(Map<String, dynamic> map) {
    return EmojiIcon(
      icon: map['icon']
    );
  }
}