// lib/views/add_edit_meal_page.dart

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../controllers/add_edit_meal_controller.dart';
import '../helpers/firestore_service.dart';
import '../models/meals_models.dart';

class AddEditMealPage extends StatefulWidget {
  final Meal? existingMeal;
  const AddEditMealPage({Key? key, this.existingMeal}) : super(key: key);

  @override
  State<AddEditMealPage> createState() => _AddEditMealPageState();
}

class _AddEditMealPageState extends State<AddEditMealPage> {
  final _formKey = GlobalKey<FormState>();
  late final AddEditMealController _controller;

  // backing meal (cloned if editing)
  late Meal _baseMeal;

  // text controllers
  late final TextEditingController _titleCtrl,
      _descCtrl,
      _portionCtrl,
      _caloriesCtrl,
      _proteinCtrl,
      _carbsCtrl,
      _fatsCtrl;

  // image state
  File? _pickedImage;
  bool _removeExistingPhoto = false;

  // other form state
  String _type = 'Breakfast';
  DateTime _timestamp = DateTime.now();
  bool _loading = false;
  String? _errorText;

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AddEditMealController(FirestoreService());
    _baseMeal = widget.existingMeal?.copyWith() ??
        Meal(
          id: '',
          type: 'Breakfast',
          title: '',
          description: '',
          portion: '',
          timestamp: DateTime.now(),
        );

    _type = _baseMeal.type;
    _timestamp = _baseMeal.timestamp;

    _titleCtrl = TextEditingController(text: _baseMeal.title);
    _descCtrl = TextEditingController(text: _baseMeal.description);
    _portionCtrl = TextEditingController(text: _baseMeal.portion);
    _caloriesCtrl =
        TextEditingController(text: _baseMeal.calories?.toString() ?? '');
    _proteinCtrl =
        TextEditingController(text: _baseMeal.protein?.toString() ?? '');
    _carbsCtrl = TextEditingController(text: _baseMeal.carbs?.toString() ?? '');
    _fatsCtrl = TextEditingController(text: _baseMeal.fats?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _portionCtrl.dispose();
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _carbsCtrl.dispose();
    _fatsCtrl.dispose();
    super.dispose();
  }

  Future<void> _chooseImageSource() async {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            if (isIOS)
              CupertinoButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              )
            else
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
    if (option != null) {
      final picked = await _picker.pickImage(
        source: option,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _pickedImage = File(picked.path);
          _removeExistingPhoto = false;
        });
      }
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timestamp),
    );
    if (time == null) return;
    setState(() {
      _timestamp =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
  String? _number(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return int.tryParse(v.trim()) == null ? 'Invalid number' : null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorText = null;
    });

    // build updated meal
    final updated = _baseMeal.copyWith(
      type: _type,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      portion: _portionCtrl.text.trim(),
      timestamp: _timestamp,
      calories: int.tryParse(_caloriesCtrl.text.trim()),
      protein: int.tryParse(_proteinCtrl.text.trim()),
      carbs: int.tryParse(_carbsCtrl.text.trim()),
      fats: int.tryParse(_fatsCtrl.text.trim()),
    );

    try {
      // if you implement photo upload in your controller:
      // if (_pickedImage != null) {
      //   await _controller.uploadPhoto(updated.id, _pickedImage!);
      // }
      await _controller.saveMeal(updated);
      if (!mounted) return;
      Navigator.pop(context);
    } on MealSaveException catch (e) {
      setState(() => _errorText = e.message);
    } catch (e) {
      setState(() => _errorText = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildPhotoPicker() {
    // three states: picked, original (and not removed), placeholder
    if (_pickedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_pickedImage!, height: 140, fit: BoxFit.cover),
      );
    }
    if (_baseMeal.photoUrl != null && !_removeExistingPhoto) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(_baseMeal.photoUrl!,
                height: 140, fit: BoxFit.cover),
          ),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Remove photo',
                  onPressed: () => setState(() => _removeExistingPhoto = true),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  tooltip: 'Replace photo',
                  onPressed: _chooseImageSource,
                ),
              ],
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: _chooseImageSource,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text('Tap to add photo', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final titleText = widget.existingMeal == null ? 'Add Meal' : 'Edit Meal';

    final form = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorText != null) ...[
              Text(
                _errorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            _buildPhotoPicker(),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Meal Type'),
              items: ['Breakfast', 'Lunch', 'Dinner']
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
              maxLength: 100,
              validator: _required,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              maxLength: 300,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _portionCtrl,
              decoration:
                  const InputDecoration(labelText: 'Portion / Quantity'),
              validator: _required,
            ),
            const SizedBox(height: 12),

            // optional numeric fields
            for (final pair in [
              ['Calories (optional)', _caloriesCtrl],
              ['Protein (g, optional)', _proteinCtrl],
              ['Carbs (g, optional)', _carbsCtrl],
              ['Fats (g, optional)', _fatsCtrl],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextFormField(
                  controller: pair[1] as TextEditingController,
                  decoration: InputDecoration(labelText: pair[0] as String),
                  keyboardType: TextInputType.number,
                  validator: _number,
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    'When: ${DateFormat.yMMMd().add_jm().format(_timestamp)}',
                  ),
                ),
                TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Change'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            isIOS
                ? CupertinoButton.filled(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const CupertinoActivityIndicator()
                        : Text(titleText),
                  )
                : ElevatedButton(
                    onPressed: _loading ? null : _save,
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(titleText),
                  ),
          ],
        ),
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text(titleText)),
            child: SafeArea(child: form),
          )
        : Scaffold(
            appBar: AppBar(title: Text(titleText)),
            body: form,
          );
  }
}
