// Example of how to update your settings screen logout function to use Firebase

// In your settings_screen.dart, replace the _performLogout method with this:

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
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signing out...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Sign out using Firebase
      await authProvider.signOut();

      // Navigate to auth choice screen
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/auth-choice',
          (route) => false,
        );
      }
    } catch (e) {
      // Show error message
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

// Also add this import at the top of your settings_screen.dart:
// import '../../providers/auth_provider.dart';
