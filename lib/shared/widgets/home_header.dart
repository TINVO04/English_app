import 'package:flutter/material.dart';

import '../../core/config/constants/services/spacing.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSettingsTap;

  const HomeHeader({
    super.key,
    required this.name,
    this.onNotificationsTap,
    this.onSettingsTap,
  });

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final textScale = media.textScaleFactor.clamp(1.0, 1.2);

    return MediaQuery(
      data: media.copyWith(textScaleFactor: textScale),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE8F0FF),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'G',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chào mừng, ${_cap(name)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    )),
                Text(
                  'Sẵn sàng cho các lớp hôm nay chứ?',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: onNotificationsTap,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
}
