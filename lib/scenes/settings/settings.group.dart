import 'package:flutter/material.dart';
import 'package:wallet/scenes/settings/settings.item.dart';

/// group
class SettingsGroup extends StatelessWidget {
  final List<SettingsItem> children;

  const SettingsGroup({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          for (final child in children) ...[
            if (!child.hidden) ...[
              if (child.subtitle != null) ...[
                const SizedBox(height: 6),
              ] else ...[
                const SizedBox(height: 12),
              ],
              child,
              if (child.subtitle != null) ...[
                const SizedBox(height: 6),
              ] else ...[
                const SizedBox(height: 12),
              ],
              if (children.last != child) ...[
                const Divider(thickness: 0.2, height: 1),
              ],
            ],
          ],
        ],
      ),
    );
  }
}
