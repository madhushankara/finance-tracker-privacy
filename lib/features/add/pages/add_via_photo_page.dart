import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import 'under_development_page.dart';

final class AddViaPhotoPage extends StatelessWidget {
  const AddViaPhotoPage({super.key});

  static const _subtext = 'This feature will be available in a future update.';

  void _openUnderDevelopment(BuildContext context) {
    context.push(
      Routes.underDevelopment,
      extra: const UnderDevelopmentArgs(
        message:
            'Photo-based transaction extraction is currently under development.',
        subtext: _subtext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add via Photo')),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: <Widget>[
          _OptionCard(
            icon: Icons.upload_file_outlined,
            title: 'Upload photo',
            onTap: () => _openUnderDevelopment(context),
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.photo_camera_outlined,
            title: 'Take photo',
            onTap: () => _openUnderDevelopment(context),
          ),
          const SizedBox(height: AppSpacing.s16),
          _OptionCard(
            icon: Icons.photo_library_outlined,
            title: 'Upload from gallery',
            onTap: () => _openUnderDevelopment(context),
          ),
        ],
      ),
    );
  }
}

final class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: <Widget>[
              Icon(icon, color: cs.primary),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
