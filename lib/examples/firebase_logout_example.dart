
// Example widget for reference only. Not for production use.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class FirebaseLogoutExample extends StatefulWidget {
  const FirebaseLogoutExample({super.key});

  @override
  State<FirebaseLogoutExample> createState() => _FirebaseLogoutExampleState();
}

class _FirebaseLogoutExampleState extends State<FirebaseLogoutExample> {
  Future<void> _performLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Show confirmation dialog
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signing out...'),
              duration: Duration(seconds: 1),
            ),
          );
        }
        await authProvider.signOut();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/auth-choice',
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing out: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _performLogout,
        child: const Text('Logout Example'),
      ),
    );
  }
}
