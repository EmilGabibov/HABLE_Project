import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  static const List<String> _defaultAvatarEmojis = [
    '🌱',
    '🌞',
    '🌊',
    '🍀',
    '🪴',
    '🧠',
    '🧭',
    '🔥',
    '⭐',
    '🌻',
    '🦊',
    '👺',
  ];

  final String? avatarUrl;
  final String? username;
  final double radius;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.username,
    this.radius = 28.0,
    this.backgroundColor,
  });

  bool get _isEmoji {
    if (avatarUrl == null) return false;
    // An emoji is typically short, while URLs are much longer.
    return !avatarUrl!.startsWith('http') && avatarUrl!.length < 15;
  }

  int _hashString(String value) {
    var hash = 0;
    for (final rune in value.runes) {
      hash = ((hash * 31) + rune) & 0x7fffffff;
    }
    return hash;
  }

  String? get _derivedDefaultEmoji {
    final value = avatarUrl;
    if (value == null || !value.startsWith('http')) return null;

    final uri = Uri.tryParse(value);
    if (uri == null || uri.host != 'api.dicebear.com') return null;

    final seed = uri.queryParameters['seed']?.trim();
    if (seed == null || seed.isEmpty) return null;

    return _defaultAvatarEmojis[_hashString(seed.toLowerCase()) %
        _defaultAvatarEmojis.length];
  }

  bool get _isSvgUrl {
    final value = avatarUrl;
    if (value == null || !value.startsWith('http')) return false;

    final normalized = value.toLowerCase();
    if (normalized.endsWith('.svg') || normalized.contains('/svg?')) {
      return true;
    }

    final uri = Uri.tryParse(value);
    return uri?.path.toLowerCase().endsWith('/svg') == true;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? AppTheme.sageGreen.withValues(alpha: 0.15);
    final size = radius * 2;
    final emojiAvatar = _isEmoji ? avatarUrl : _derivedDefaultEmoji;

    if (emojiAvatar != null && emojiAvatar.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Center(
          child: Text(emojiAvatar, style: TextStyle(fontSize: radius)),
        ),
      );
    }

    if (avatarUrl != null && avatarUrl!.startsWith('http') && !_isSvgUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    // Fallback to username initial
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          username?.isNotEmpty == true ? username![0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.w700,
            color: AppTheme.sageGreen,
          ),
        ),
      ),
    );
  }
}
