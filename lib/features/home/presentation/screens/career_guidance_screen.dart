import 'package:flutter/material.dart';

class CareerGuidanceScreen extends StatelessWidget {
  const CareerGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Career Guidance', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discover Your Dream Career 🚀',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Take AI Career Assessment Test to find best streams & roadmap.',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF4F46E5)),
                    child: const Text('Take Career Test →'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Explore Career Fields', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildFieldCard(Icons.engineering, 'Engineering', const Color(0xFF6366F1)),
                _buildFieldCard(Icons.medical_services, 'Medical', const Color(0xFF10B981)),
                _buildFieldCard(Icons.business_center, 'Management', const Color(0xFFF59E0B)),
                _buildFieldCard(Icons.palette, 'Design', const Color(0xFFEC4899)),
                _buildFieldCard(Icons.gavel, 'Law', const Color(0xFF8B5CF6)),
                _buildFieldCard(Icons.computer, 'Data & AI', const Color(0xFF0EA5E9)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCard(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }
}
