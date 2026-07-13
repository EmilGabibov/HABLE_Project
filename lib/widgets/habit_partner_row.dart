import 'package:flutter/material.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../theme/app_theme.dart';
import 'user_avatar.dart';

class HabitPartnerRow extends StatefulWidget {
  final List<PartnerSnapshot> partners;
  final Color habitColor;
  final int maxVisible;
  final bool compactMode;
  final void Function(PartnerSnapshot partner)? onProfileTap;
  final void Function(PartnerSnapshot partner)? onNudgeTap;

  const HabitPartnerRow({
    super.key,
    required this.partners,
    required this.habitColor,
    this.maxVisible = 4,
    this.compactMode = false,
    this.onProfileTap,
    this.onNudgeTap,
  });

  @override
  State<HabitPartnerRow> createState() => _HabitPartnerRowState();
}

class _HabitPartnerRowState extends State<HabitPartnerRow> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.partners.isEmpty) {
      return Semantics(
        label: 'No partners on this habit yet.',
        child: Text(
          'No partners',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.warmGray),
        ),
      );
    }

    final visiblePartners = widget.partners.take(widget.maxVisible).toList();
    final overflowCount = (widget.partners.length - visiblePartners.length).clamp(
      0,
      widget.partners.length,
    );

    if (!_isExpanded) {
      return GestureDetector(
        onLongPress: _toggleExpanded,
        onTap: _toggleExpanded,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 40,
          width: visiblePartners.length * 24.0 + (overflowCount > 0 ? 44.0 : 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < visiblePartners.length; i++)
                Positioned(
                  left: i * 24.0,
                  top: 2,
                  child: _PartnerAvatar(
                    partner: visiblePartners[i],
                    habitColor: widget.habitColor,
                  ),
                ),
              if (overflowCount > 0)
                Positioned(
                  left: visiblePartners.length * 24.0,
                  top: 2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$overflowCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.deepCharcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: _toggleExpanded,
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              direction: widget.compactMode ? Axis.vertical : Axis.horizontal,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final partner in visiblePartners)
                  _PartnerChip(
                    partner: partner,
                    habitColor: widget.habitColor,
                    onProfileTap: widget.onProfileTap == null
                        ? null
                        : () => widget.onProfileTap!(partner),
                    onNudgeTap: widget.onNudgeTap == null
                        ? null
                        : () => widget.onNudgeTap!(partner),
                    compactMode: widget.compactMode,
                  ),
                if (overflowCount > 0)
                  Semantics(
                    label: '$overflowCount more partners hidden.',
                    child: Container(
                      key: const Key('partner-overflow-chip'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '+$overflowCount',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.deepCharcoal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerAvatar extends StatelessWidget {
  final PartnerSnapshot partner;
  final Color habitColor;

  const _PartnerAvatar({
    required this.partner,
    required this.habitColor,
  });

  @override
  Widget build(BuildContext context) {
    final wasNudgedRecently = _wasNudgedRecently(partner.lastNudgeAt);
    final borderColor = partner.hasCompletedToday
        ? habitColor
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.85)
        : partner.role == PartnershipRole.supporter
        ? AppTheme.mutedLavender
        : AppTheme.warmGray.withValues(alpha: 0.5);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 2.5,
            ),
          ),
          child: UserAvatar(
            avatarUrl: partner.avatarUrl,
            username: partner.username,
            radius: 16,
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: partner.hasCompletedToday
                  ? AppTheme.completionGreen
                  : partner.role == PartnershipRole.supporter
                  ? AppTheme.mutedLavender
                  : AppTheme.warmGray,
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PartnerChip extends StatelessWidget {
  final PartnerSnapshot partner;
  final Color habitColor;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNudgeTap;
  final bool compactMode;

  const _PartnerChip({
    required this.partner,
    required this.habitColor,
    this.onProfileTap,
    this.onNudgeTap,
    this.compactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final roleLabel = switch (partner.role) {
      PartnershipRole.owner => 'owner',
      PartnershipRole.partner => 'partner',
      PartnershipRole.supporter => 'supporter',
    };
    final statusLabel = partner.hasCompletedToday
        ? 'completed today'
        : 'not completed today';
    final wasNudgedRecently = _wasNudgedRecently(partner.lastNudgeAt);
    final borderColor = partner.hasCompletedToday
        ? habitColor
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.85)
        : partner.role == PartnershipRole.supporter
        ? AppTheme.mutedLavender
        : AppTheme.warmGray.withValues(alpha: 0.5);
    final fillColor = partner.hasCompletedToday
        ? habitColor.withValues(alpha: 0.12)
        : wasNudgedRecently
        ? habitColor.withValues(alpha: 0.1)
        : AppTheme.surfaceVariant;

    return Container(
      constraints: const BoxConstraints(maxWidth: 204),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Semantics(
              label:
                  '${partner.username}, $roleLabel, $statusLabel${wasNudgedRecently ? ", nudged recently" : ""}. Opens profile.',
              button: onProfileTap != null,
              child: InkWell(
                key: Key('partner-profile-${partner.partnerUserId}'),
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _PartnerAvatar(partner: partner, habitColor: habitColor),
                      if (!compactMode) ...[
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                partner.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.deepCharcoal,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                wasNudgedRecently ? 'nudged' : roleLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: wasNudgedRecently
                                          ? habitColor
                                          : partner.role ==
                                                PartnershipRole.supporter
                                          ? AppTheme.mutedLavender
                                          : borderColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onNudgeTap != null)
            Semantics(
              label: 'Nudge ${partner.username} on this habit.',
              button: true,
              child: Tooltip(
                message: 'Nudge ${partner.username}',
                child: IconButton(
                  key: Key('partner-nudge-${partner.partnerUserId}'),
                  onPressed: onNudgeTap,
                  icon: const Icon(Icons.back_hand_rounded, size: 18),
                  color: habitColor,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          if (onNudgeTap != null) const SizedBox(width: 4),
        ],
      ),
    );
  }
}

bool _wasNudgedRecently(DateTime? lastNudgeAt) {
  if (lastNudgeAt == null) return false;
  return lastNudgeAt.isAfter(
    DateTime.now().subtract(const Duration(hours: 24)),
  );
}
