import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../models/user_profile.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadCurrentProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadProfileData(UserProfile profile) {
    _nameController.text = profile.displayName;
    _emailController.text = profile.email;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'backup',
                child: Row(
                  children: [
                    Icon(Icons.backup),
                    SizedBox(width: 8),
                    Text('Create Backup'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'analytics',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('View Analytics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'soft_delete',
                child: Row(
                  children: [
                    Icon(Icons.archive, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Archive Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'hard_delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Permanently'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading profile...'),
                ],
              ),
            );
          }

          if (profileProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${profileProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => profileProvider.loadCurrentProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final profile = profileProvider.currentProfile;
          if (profile == null) {
            return _buildCreateProfileForm();
          }

          // Load profile data into controllers when profile is available
          if (!_isEditing && _nameController.text.isEmpty) {
            _loadProfileData(profile);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            child: Column(
              children: [
                _buildProfileHeader(profile),
                const SizedBox(height: 24),
                _buildProfileForm(profile),
                const SizedBox(height: 24),
                _buildStatsSection(profile),
                const SizedBox(height: 24),
                _buildSettingsSection(profile, profileProvider),
                const SizedBox(height: 24),
                _buildActionButtons(profileProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreateProfileForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_add, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          const Text(
            'Create Your Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _createProfile,
                  child: const Text('Create Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: profile.photoURL != null
                  ? NetworkImage(profile.photoURL!)
                  : null,
              child: profile.photoURL == null
                  ? Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 24),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profile.email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Member since ${_formatDate(profile.createdAt)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (!_isEditing)
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () => _showPhotoOptions(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person),
                ),
                enabled: _isEditing,
                validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                enabled: _isEditing,
                validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(UserProfile profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total XP',
                    profile.stats.totalXP.toString(),
                    Icons.stars,
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Lessons',
                    profile.stats.lessonsCompleted.toString(),
                    Icons.book,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Current Streak',
                    '${profile.stats.currentStreak} days',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Max Streak',
                    '${profile.stats.maxStreak} days',
                    Icons.emoji_events,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(UserProfile profile, UserProfileProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Receive learning reminders'),
              value: profile.settings.notifications,
              onChanged: (value) {
                provider.updateSettings(notifications: value);
              },
            ),
            SwitchListTile(
              title: const Text('Sound Effects'),
              subtitle: const Text('Play sounds during lessons'),
              value: profile.settings.soundEnabled,
              onChanged: (value) {
                provider.updateSettings(soundEnabled: value);
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              value: profile.settings.darkMode,
              onChanged: (value) {
                provider.updateSettings(darkMode: value);
              },
            ),
            ListTile(
              title: const Text('Daily Goal'),
              subtitle: Text('${profile.settings.dailyGoal} minutes'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editDailyGoal(profile.settings.dailyGoal, provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(UserProfileProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _addXP(provider),
                icon: const Icon(Icons.add),
                label: const Text('Add 100 XP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _completeLesson(provider),
                icon: const Icon(Icons.check),
                label: const Text('Complete Lesson'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _exportData(provider),
          icon: const Icon(Icons.download),
          label: const Text('Export Profile Data'),
        ),
      ],
    );
  }

  // Action methods
  void _createProfile() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<UserProfileProvider>();
      final success = await provider.createProfile(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}', // Demo UID
        displayName: _nameController.text,
        email: _emailController.text,
      );

      if (success) {
        _showSnackBar('Profile created successfully!', Colors.green);
      } else {
        _showSnackBar('Failed to create profile', Colors.red);
      }
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<UserProfileProvider>();
      final success = await provider.updateProfile({
        'displayName': _nameController.text,
        'email': _emailController.text,
      });

      if (success) {
        setState(() => _isEditing = false);
        _showSnackBar('Profile updated successfully!', Colors.green);
      } else {
        _showSnackBar('Failed to update profile', Colors.red);
      }
    }
  }

  void _handleMenuAction(String action) async {
    final provider = context.read<UserProfileProvider>();

    switch (action) {
      case 'backup':
        final success = await provider.backupCurrentProfile();
        _showSnackBar(
          success ? 'Backup created successfully!' : 'Failed to create backup',
          success ? Colors.green : Colors.red,
        );
        break;
      case 'analytics':
        _showAnalytics();
        break;
      case 'soft_delete':
        _confirmSoftDelete();
        break;
      case 'hard_delete':
        _confirmHardDelete();
        break;
    }
  }

  void _addXP(UserProfileProvider provider) async {
    final success = await provider.addXP(100);
    _showSnackBar(
      success ? '100 XP added!' : 'Failed to add XP',
      success ? Colors.green : Colors.red,
    );
  }

  void _completeLesson(UserProfileProvider provider) async {
    final success = await provider.completeLesson('demo_lesson', 0.95); // 95% score
    _showSnackBar(
      success ? 'Lesson completed!' : 'Failed to complete lesson',
      success ? Colors.green : Colors.red,
    );
  }

  void _editDailyGoal(int currentGoal, UserProfileProvider provider) {
    final controller = TextEditingController(text: currentGoal.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Daily Goal'),
        content: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Minutes per day',
            suffix: Text('min'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newGoal = int.tryParse(controller.text) ?? currentGoal;
              provider.updateSettings(dailyGoal: newGoal);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement photo picker
              _showSnackBar('Photo picker not implemented yet', Colors.orange);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement camera
              _showSnackBar('Camera not implemented yet', Colors.orange);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Photo'),
            onTap: () {
              Navigator.pop(context);
              context.read<UserProfileProvider>().updateProfilePhoto('');
            },
          ),
        ],
      ),
    );
  }

  void _showAnalytics() async {
    final provider = context.read<UserProfileProvider>();
    final analytics = await provider.getUserAnalytics();
    
    if (analytics != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Analytics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: analytics.entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(entry.value.toString()),
                  ],
                ),
              )
            ).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  void _confirmSoftDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Profile'),
        content: const Text(
          'This will archive your profile. You can restore it later if needed. '
          'Your data will be preserved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<UserProfileProvider>().softDeleteProfile();
              _showSnackBar(
                success ? 'Profile archived' : 'Failed to archive profile',
                success ? Colors.orange : Colors.red,
              );
            },
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  void _confirmHardDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile Permanently'),
        content: const Text(
          '⚠️ This action cannot be undone! Your profile and all data will be '
          'permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<UserProfileProvider>().permanentDeleteProfile();
              _showSnackBar(
                success ? 'Profile permanently deleted' : 'Failed to delete profile',
                success ? Colors.red : Colors.red,
              );
              if (success) Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE FOREVER'),
          ),
        ],
      ),
    );
  }

  void _exportData(UserProfileProvider provider) {
    // TODO: Implement data export
    _showSnackBar('Data export not implemented yet', Colors.orange);
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
