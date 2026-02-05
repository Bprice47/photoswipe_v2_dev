import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../config/routes.dart';
import '../widgets/app_logo.dart';

/// App Drawer (Hamburger Menu)
/// Contains navigation to legal pages and app info
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundMain,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            const Divider(color: AppTheme.dividerColor, height: 1),

            // Menu Items
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.shield_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _navigateTo(context, AppRoutes.privacyPolicy),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => _navigateTo(context, AppRoutes.termsOfService),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.warning_amber_outlined,
                    title: 'Disclaimer',
                    onTap: () => _navigateTo(context, AppRoutes.disclaimer),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                      vertical: AppTheme.spacingSm,
                    ),
                    child: Divider(color: AppTheme.dividerColor),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () => _navigateTo(context, AppRoutes.about),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.mail_outline,
                    title: 'Contact Support',
                    onTap: () => _navigateTo(context, AppRoutes.contact),
                  ),
                ],
              ),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          const AppLogo(size: 48),
          const SizedBox(width: AppTheme.spacingMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: AppTheme.h3,
              ),
              const SizedBox(height: 2),
              Text(
                'v${AppConstants.appVersion}',
                style: AppTheme.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.body,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textMuted,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingLg,
        vertical: AppTheme.spacingXs,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        children: [
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            '© 2025 Priceless Concepts LLC',
            style: AppTheme.small.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'All rights reserved',
            style: AppTheme.small.copyWith(
              color: AppTheme.textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer first
    AppRoutes.navigateTo(context, route);
  }
}
