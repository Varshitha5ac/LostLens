
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile information.
  String _displayName = 'Campus Member';
  String _displayEmail = 'member@lostlens.app';

  // Automatically generate avatar initials.
  String get _initials {
    final parts = _displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    return parts
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  // Preferences.
  bool notificationsEnabled = true;
  bool emailUpdatesEnabled = false;

  // Display messages.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.evergreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Edit profile.
  void showEditProfile() {
    final nameController = TextEditingController(
      text: _displayName,
    );

    final emailController = TextEditingController(
      text: _displayEmail,
    );

    final editFormKey = GlobalKey<FormState>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            24,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Edit profile',
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Update your personal information.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Full name.
                  TextFormField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration('Full name'),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Email address.
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration('Email address'),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter your email.';
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value.trim())) {
                        return 'Please enter a valid email address.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  // Save changes.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.evergreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (!editFormKey.currentState!.validate()) {
                          return;
                        }

                        // Update the ProfileScreen state.
                        setState(() {
                          _displayName =
                              nameController.text.trim();

                          _displayEmail =
                              emailController.text.trim();
                        });

                        Navigator.pop(sheetContext);

                        showMessage(
                          'Profile updated successfully!',
                        );
                      },
                      child: const Text(
                        'Save changes',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
   );
  }

  // Common input field styling.
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.paper,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.evergreen,
          width: 1.5,
        ),
      ),
    );
  }

  // Sign out demonstration dialog.
  void showSignOutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Sign out?',
            style: TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Authentication is not enabled yet. '
            'This action is currently a UI demonstration.',
            style: TextStyle(
              color: AppColors.muted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.muted,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showMessage(
                  'Sign out will be available after authentication is added.',
                );
              },
              child: const Text(
                'Okay',
                style: TextStyle(
                  color: AppColors.coral,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            18,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page heading.
              const Text(
                'YOUR SPACE',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'My Profile',
                style: TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 23),

              // Profile card.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.evergreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Dynamic avatar.
                        Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            color: AppColors.sage,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white54,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              color: AppColors.evergreen,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        // Dynamic name and email.
                       Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _displayName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
      ),

      const SizedBox(height: 5),

      Text(
        _displayEmail,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 9),

      const Row(
        children: [
          Icon(
            Icons.verified_rounded,
            color: AppColors.highlight,
            size: 14,
          ),
          SizedBox(width: 5),
          Text(
            'CAMPUS MEMBER',
            style: TextStyle(
              color: AppColors.highlight,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ],
  ),
),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Edit profile button.
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: showEditProfile,
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                        ),
                        label: const Text('Edit profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white54,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Contribution heading.
              const Text(
                'YOUR CONTRIBUTION',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),

              const SizedBox(height: 12),

              // Statistics.
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      '03',
                      'Reports',
                      Icons.assignment_outlined,
                      AppColors.coral,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      '02',
                      'Found items',
                      Icons.inventory_2_outlined,
                      AppColors.evergreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statCard(
                      '01',
                      'Returned',
                      Icons.check_circle_outline_rounded,
                      AppColors.sage,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Account section.
              _sectionHeading('ACCOUNT'),
              const SizedBox(height: 10),

              _menuCard([
                _menuItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal information',
                  subtitle: 'Manage your profile details',
                  onTap: showEditProfile,
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'My reports',
                  subtitle: 'View your lost and found reports',
                  onTap: () {
                    showMessage('My reports UI coming soon.');
                  },
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.bookmark_border_rounded,
                  title: 'Saved items',
                  subtitle: 'Items you have bookmarked',
                  onTap: () {
                    showMessage('Saved items UI coming soon.');
                  },
                ),
              ]),

              const SizedBox(height: 25),

              // Preferences section.
              _sectionHeading('PREFERENCES'),
              const SizedBox(height: 10),

              _menuCard([
                _switchItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push notifications',
                  subtitle: 'Get updates about your reports',
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
                _menuDivider(),
                _switchItem(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email updates',
                  subtitle: 'Receive important updates via email',
                  value: emailUpdatesEnabled,
                  onChanged: (value) {
                    setState(() {
                      emailUpdatesEnabled = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 25),

              // Support section.
              _sectionHeading('SUPPORT & INFORMATION'),
              const SizedBox(height: 10),

              _menuCard([
                _menuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  subtitle: 'Get help using LostLens',
                  onTap: () {
                    showMessage('Help & support coming soon.');
                  },
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy & security',
                  subtitle: 'Manage your privacy preferences',
                  onTap: () {
                    showMessage('Privacy settings coming soon.');
                  },
                ),
                _menuDivider(),
                _menuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About LostLens',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    showMessage(
                      'LostLens — Smart Lost & Found Platform.',
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // Sign out.
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: showSignOutDialog,
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                  ),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral,
                    side: const BorderSide(
                      color: AppColors.coral,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Footer.
              const Center(
                child: Column(
                  children: [
                    Text(
                      'LOSTLENS',
                      style: TextStyle(
                        color: AppColors.evergreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Helping lost things find their way home.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section heading.
  Widget _sectionHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.6,
      ),
    );
  }

  // Contribution statistic card.
  Widget _statCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Menu card container.
  Widget _menuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(children: children),
    );
  }

  // Menu divider.
  Widget _menuDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 58,
      color: AppColors.divider,
    );
  }

  // Individual menu item.
  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      leading: Icon(
        icon,
        color: AppColors.evergreen,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.charcoal,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.muted,
        size: 20,
      ),
    );
  }

  // Preference switch item.
  Widget _switchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 3,
      ),
      leading: Icon(
        icon,
        color: AppColors.evergreen,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.charcoal,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.evergreen,
      ),
    );
  }
}
