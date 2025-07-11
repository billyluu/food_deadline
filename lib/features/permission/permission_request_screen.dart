import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/utils/permission_helper.dart';
import 'package:food_deadline/features/main/main_screen.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo 或圖標
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.notifications_active,
                size: 60,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 32),
            
            // 標題
            Text(
              AppString.permissionWelcomeTitle.getI18n(context, [AppString.appName.getI18n(context)]),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // 說明文字
            Text(
              AppString.permissionWelcomeDescription.getI18n(context),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // 功能說明
            _buildFeatureItem(
              context,
              Icons.schedule,
              AppString.permissionFeatureTimely.getI18n(context),
              AppString.permissionFeatureTimelyDesc.getI18n(context),
            ),
            const SizedBox(height: 24),
            
            _buildFeatureItem(
              context,
              Icons.warning_amber,
              AppString.permissionFeatureWarning.getI18n(context),
              AppString.permissionFeatureWarningDesc.getI18n(context),
            ),
            const SizedBox(height: 24),
            
            _buildFeatureItem(
              context,
              Icons.settings,
              AppString.permissionFeatureCustom.getI18n(context),
              AppString.permissionFeatureCustomDesc.getI18n(context),
            ),
            const SizedBox(height: 64),
            
            // 按鈕
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handlePermissionRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        AppString.permissionGrantButton.getI18n(context),
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 跳過按鈕
            TextButton(
              onPressed: _isLoading ? null : _skipPermissions,
              child: Text(
                AppString.permissionLaterButton.getI18n(context),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handlePermissionRequest() async {
    setState(() => _isLoading = true);
    
    try {
      await PermissionHelper.requestAllPermissions(context);
      _navigateToMainScreen();
    } catch (e) {
      // 即使權限請求失敗，也允許用戶繼續使用
      _navigateToMainScreen();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _skipPermissions() {
    _navigateToMainScreen();
  }

  void _navigateToMainScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  }
}