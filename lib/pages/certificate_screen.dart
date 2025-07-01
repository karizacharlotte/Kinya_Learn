import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../theme/app_theme.dart';

class CertificateScreen extends StatelessWidget {
  final Lesson lesson;

  const CertificateScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        title: const Text('Certificate of Completion'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: IntrinsicHeight(
          child: Column(
            children: [
              // Certificate Preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 78, 42, 147),
                                Color.fromARGB(255, 78, 42, 147),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.school,
                              color: Colors.white, size: 25),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KinyaLearn',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 78, 42, 147),
                              ),
                            ),
                            Text(
                              'Language Learning Platform',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'CERTIFICATE OF COMPLETION',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text('This is to certify that'),
                    const SizedBox(height: 8),
                    const Text(
                      'SARAH JOHNSON',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 78, 42, 147),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('has successfully completed'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 78, 42, 147),
                            Color.fromARGB(255, 78, 42, 147),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        lesson.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                                width: 80, height: 1, color: AppTheme.border),
                            const SizedBox(height: 4),
                            const Text('Date', style: TextStyle(fontSize: 10)),
                            Text(DateTime.now().toString().split(' ')[0]),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                width: 80, height: 1, color: AppTheme.border),
                            const SizedBox(height: 4),
                            const Text('Signature',
                                style: TextStyle(fontSize: 10)),
                            const Text('KinyaLearn',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Download buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Certificate downloaded!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 78, 42, 147),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Download PDF Certificate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
