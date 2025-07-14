import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class PaymentScreen extends StatelessWidget {
  final Lesson lesson;
  const PaymentScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: const Text(
          'Premium Quiz Access',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Premium features
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryOrange,
                    AppTheme.primaryOrange,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.workspace_premium,
                      color: Colors.white, size: 32),
                  const SizedBox(height: 16),
                  const Text(
                    'Unlock Premium Features',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('📝 Final certification quiz',
                      style: TextStyle(color: Colors.white)),
                  const Text('🏆 Official completion certificate',
                      style: TextStyle(color: Colors.white)),
                  const Text('📊 Detailed performance analytics',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pricing
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Text(
                    'Final Quiz & Certificate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$9.99',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Purchase button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryOrange),
                    ),
                  );

                  await Future.delayed(const Duration(seconds: 2));
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog
                    Navigator.pushReplacementNamed(
                      context,
                      '/final-quiz',
                      arguments: lesson,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppTheme.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Purchase Access - \$9.99'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

