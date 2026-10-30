import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../core/theme/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final String initialType;

  const ReportScreen({
    super.key,
    this.initialType = 'Lost',
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colourController = TextEditingController();
  final _locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  late String _reportType;

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

Uint8List? _selectedImageBytes;
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Electronics',
    'ID Cards',
    'Accessories',
    'Books',
    'Clothing',
    'Bags',
    'Others',
  ];

  @override
  void initState() {
    super.initState();
    _reportType = widget.initialType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _colourController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Pick an image from the gallery.
  Future<void> _pickImage() async {
  try {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  } catch (e) {
    if (!mounted) return;
    _showMessage('Unable to select image. Please try again.');
  }
}

  // Remove selected image.
  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
    });
  }

  // Select reported date.
  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.evergreen,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.charcoal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.evergreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Validate and simulate submission.
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      _showMessage('Please select an item category.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.evergreen,
            size: 55,
          ),
          title: const Text(
            'Report Submitted!',
            style: TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Your item report has been prepared successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        );
      },
    );
  }

  // Common input styling.
  InputDecoration _inputDecoration(
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 20,
        color: AppColors.muted,
      ),
      filled: true,
      fillColor: AppColors.paper,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 16,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        title: const Text(
          'Report an Item',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 19,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  35,
                ),
                children: [
                  _buildIntro(),

                  const SizedBox(height: 25),

                  // Report type selection.
                  _sectionHeading(
                    '01',
                    'REPORT TYPE',
                    'Tell us what happened.',
                  ),

                  const SizedBox(height: 13),

                  Row(
                    children: [
                      Expanded(
                        child: _typeButton(
                          'Lost',
                          Icons.search_rounded,
                          'I cannot find it',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _typeButton(
                          'Found',
                          Icons.inventory_2_outlined,
                          'I found something',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Item details.
                  _sectionHeading(
                    '02',
                    'ITEM DETAILS',
                    'Describe the belonging.',
                  ),

                  const SizedBox(height: 13),

                  _sectionCard(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(
                            'Item name *',
                            'e.g. Black wallet, iPhone 15',
                            Icons.shopping_bag_outlined,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter the item name.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          isExpanded: true,
                          decoration: _inputDecoration(
                            'Category *',
                            'Choose a category',
                            Icons.category_outlined,
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _colourController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(
                            'Colour',
                            'e.g. Black, Blue, White',
                            Icons.palette_outlined,
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: _inputDecoration(
                            'Description *',
                            'Mention marks, brand, identifying details...',
                            Icons.notes_rounded,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please describe the item.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Photograph section.
                  _sectionHeading(
                    '03',
                    'ITEM PHOTOGRAPH',
                    'A photo makes identification easier.',
                  ),

                  const SizedBox(height: 13),

                  _buildImagePicker(),

                  const SizedBox(height: 28),

                  // Location and date.
                  _sectionHeading(
                    '04',
                    'WHERE & WHEN',
                    'Help narrow down the search.',
                  ),

                  const SizedBox(height: 13),

                  _sectionCard(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _locationController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(
                            'Location *',
                            'e.g. Library, Block A, Cafeteria',
                            Icons.location_on_outlined,
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter the location.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: AppColors.paper,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.evergreen,
                                  size: 21,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Date of incident',
                                        style: TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(_selectedDate),
                                        style: const TextStyle(
                                          color: AppColors.charcoal,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.edit_calendar_outlined,
                                  color: AppColors.muted,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Helpful note.
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.sage.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: AppColors.sage.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: AppColors.evergreen,
                          size: 21,
                        ),
                        SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            'Helpful tip: Include the exact location and '
                            'distinctive details. This can make it easier '
                            'for someone to identify the item.',
                            style: TextStyle(
                              color: AppColors.charcoal,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Submit button.
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed:
                          _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.evergreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.evergreen.withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 18),
                                SizedBox(width: 10),
                                Text(
                                  'Submit Report',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Center(
                    child: Text(
                      'LOSTLENS  /  CAMPUS COMMUNITY',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Introductory banner.
  Widget _buildIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.evergreen,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _reportType == 'Lost'
                      ? 'NEED A HAND?'
                      : 'BE SOMEONE’S HERO',
                  style: const TextStyle(
                    color: AppColors.highlight,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  _reportType == 'Lost'
                      ? 'Let’s find what you lost.'
                      : 'Help someone find their item.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'A few details can make a big difference.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            _reportType == 'Lost'
                ? Icons.search_rounded
                : Icons.volunteer_activism_outlined,
            color: AppColors.highlight,
            size: 43,
          ),
        ],
      ),
    );
  }

  // Section heading with number.
  Widget _sectionHeading(
    String number,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 29,
          width: 29,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.evergreen,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // White section card.
  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  // Lost / Found selection.
  Widget _typeButton(
    String type,
    IconData icon,
    String subtitle,
  ) {
    final bool selected = _reportType == type;

    final Color typeColor =
        type == 'Lost' ? AppColors.coral : AppColors.evergreen;

    return InkWell(
      onTap: () {
        setState(() {
          _reportType = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: selected ? typeColor : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? typeColor : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 25,
              color: selected ? Colors.white : typeColor,
            ),
            const SizedBox(height: 9),
            Text(
              'I ${type == 'Lost' ? 'Lost' : 'Found'} It',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: selected ? Colors.white : AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white70 : AppColors.muted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Photo upload area.
  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        height: 185,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child:_selectedImageBytes == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 38,
                    color: AppColors.evergreen,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add an item photo',
                    style: TextStyle(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Tap to browse your gallery',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'JPG / PNG supported',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:Image.memory(
  _selectedImageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: _removeImage,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.coral,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: 'Remove photo',
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.evergreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PHOTO ADDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
