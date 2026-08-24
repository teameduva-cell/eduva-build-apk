import 'package:flutter/material.dart';
import 'about_us_screen.dart';
import 'help_support_screen.dart';
import 'career_guidance_screen.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.person, size: 36, color: Color(0xFF4F46E5)),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Kanha Jain ✅', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Class 10th | Target: JEE 2026', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.explore, color: Color(0xFF4F46E5)),
              title: const Text('Career Guidance'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerGuidanceScreen())),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.help_center, color: Color(0xFF10B981)),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
            ),
            const SizedBox(height: 8),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              leading: const Icon(Icons.info_outline, color: Color(0xFFF59E0B)),
              title: const Text('About Eduva'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen())),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SignInScreen()), (r) => false);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout / Switch User', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
