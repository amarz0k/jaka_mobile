import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:chat_app/presentation/bloc/home/name/name_cubit.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  late TextEditingController _nameController;
  final FocusNode _nameFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image_path');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _selectedImage = File(path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    setState(() {
      isEditing = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _nameFocusNode.requestFocus();
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String uniqueName = 'profile_pic_${const Uuid().v4()}.png';
        final String newPath = '${directory.path}/$uniqueName';
        final File newImage = await File(image.path).copy(newPath);
        final prefs = await SharedPreferences.getInstance();
        final oldPath = prefs.getString('profile_image_path');
        if (oldPath != null &&
            oldPath != newPath &&
            File(oldPath).existsSync()) {
          File(oldPath).deleteSync();
        }
        await prefs.setString('profile_image_path', newImage.path);
        setState(() {
          _selectedImage = newImage;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image from gallery'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('profile_image_path');
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String uniqueName = 'profile_pic_${const Uuid().v4()}.png';
        final String newPath = '${directory.path}/$uniqueName';
        final File newImage = await File(image.path).copy(newPath);
        final prefs = await SharedPreferences.getInstance();
        final oldPath = prefs.getString('profile_image_path');
        if (oldPath != null &&
            oldPath != newPath &&
            File(oldPath).existsSync()) {
          File(oldPath).deleteSync();
        }
        await prefs.setString('profile_image_path', newImage.path);
        setState(() {
          _selectedImage = newImage;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to take photo'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        titleSpacing: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 25,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<NameCubit, NameState>(
          listener: (context, state) {
            if (state.runtimeType.toString() == 'NameUpdateSuccessState') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Name updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                isEditing = false;
              });
            } else if (state.runtimeType.toString() ==
                'NameUpdateFailureState') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update name'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FailureState) {
              return Center(child: Text('Failed to load user info'));
            }
            // For update loading
            if (state.runtimeType.toString() == 'NameUpdatingState') {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SuccessState) {
              final user = state.user;
              _nameController = TextEditingController(text: user.name);
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          // Profile Picture with tap functionality and local storage
                          GestureDetector(
                            onTap: _showImageOptions,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: _selectedImage != null
                                        ? Image.file(
                                            _selectedImage!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : ProfilePicture(
                                            name: user.name,
                                            radius: 60,
                                            fontsize: 24,
                                            random: true,
                                            count: 2,
                                          ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // User Name (tap to edit)
                          GestureDetector(
                            onTap: _enterEditMode,
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: user.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('ID copied to clipboard'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  user.id,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF767687),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.copy,
                                  size: 14,
                                  color: Color(0xFF767687),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Email
                          _buildLabel("Email Address"),
                          _buildTextField(
                            user.email,
                            suffixIcon: Icons.email,
                            borderColor: Colors.purple,
                            enabled: false,
                          ),
                          // Username
                          _buildLabel("Username"),
                          GestureDetector(
                            onTap: _enterEditMode,
                            child: AbsorbPointer(
                              absorbing: !isEditing,
                              child: TextField(
                                controller: _nameController,
                                enabled: isEditing,
                                focusNode: _nameFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.purple,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.purple,
                                    ),
                                  ),
                                  suffixIcon: isEditing
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            final newName = _nameController.text
                                                .trim();
                                            if (newName.isNotEmpty &&
                                                newName != user.name) {
                                              context
                                                  .read<NameCubit>()
                                                  .updateUserName(newName);
                                            } else {
                                              setState(() {
                                                isEditing = false;
                                              });
                                            }
                                          },
                                        )
                                      : IconButton(
                                          icon: const Icon(
                                            Icons.person,
                                            color: Colors.purple,
                                          ),
                                          onPressed: _enterEditMode,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Logout Button at bottom
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add logout logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade300,
                          side: BorderSide(
                            width: 3,
                            color: Colors.red.shade300,
                            strokeAlign: 2.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    bool enabled = true,
    bool obscureText = false,
    IconData? suffixIcon,
    Color borderColor = const Color(0xFFDDDDDD),
  }) {
    return TextField(
      enabled: enabled,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
      ),
    );
  }
}
