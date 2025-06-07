// // // // // // lib/screens/add_edit_meal_page.dart
// // // // // import 'dart:io';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // // import 'package:image_picker/image_picker.dart';
// // // // // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // // // // import 'package:meal_tracker_flutter/models/meals_models.dart';

// // // // // import 'package:firebase_storage/firebase_storage.dart';

// // // // // class AddEditMealPage extends StatefulWidget {
// // // // //   final Meal? existingMeal;
// // // // //   const AddEditMealPage({Key? key, this.existingMeal}) : super(key: key);

// // // // //   @override
// // // // //   _AddEditMealPageState createState() => _AddEditMealPageState();
// // // // // }

// // // // // class _AddEditMealPageState extends State<AddEditMealPage> {
// // // // //   final _formKey = GlobalKey<FormState>();
// // // // //   final _types = ['Breakfast', 'Lunch', 'Dinner'];
// // // // //   String? _type;
// // // // //   final _titleController = TextEditingController();
// // // // //   final _descController = TextEditingController();
// // // // //   final _quantityController = TextEditingController();
// // // // //   final _caloriesController = TextEditingController();
// // // // //   final _proteinController = TextEditingController();
// // // // //   final _carbsController = TextEditingController();
// // // // //   final _fatsController = TextEditingController();
// // // // //   DateTime _timestamp = DateTime.now();
// // // // //   File? _imageFile;
// // // // //   String? _photoUrl;
// // // // //   bool _isSaving = false;

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     final m = widget.existingMeal;
// // // // //     if (m != null) {
// // // // //       _type = m.type;
// // // // //       _titleController.text = m.title;
// // // // //       _descController.text = m.description;
// // // // //       _quantityController.text = m.quantity?.toString() ?? '';
// // // // //       _caloriesController.text = m.calories?.toString() ?? '';
// // // // //       _proteinController.text = m.protein?.toString() ?? '';
// // // // //       _carbsController.text = m.carbs?.toString() ?? '';
// // // // //       _fatsController.text = m.fats?.toString() ?? '';
// // // // //       _timestamp = m.timestamp;
// // // // //       _photoUrl = m.photoUrl;
// // // // //     }
// // // // //   }

// // // // //   Future<void> _pickImage() async {
// // // // //     final picker = ImagePicker();
// // // // //     final picked = await picker.pickImage(source: ImageSource.camera);
// // // // //     if (picked != null) {
// // // // //       setState(() {
// // // // //         _imageFile = File(picked.path);
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   Future<void> _selectDateTime() async {
// // // // //     final date = await showDatePicker(
// // // // //       context: context,
// // // // //       initialDate: _timestamp,
// // // // //       firstDate: DateTime(2000),
// // // // //       lastDate: DateTime.now(),
// // // // //     );
// // // // //     if (date == null) return;
// // // // //     final time = await showTimePicker(
// // // // //       context: context,
// // // // //       initialTime: TimeOfDay.fromDateTime(_timestamp),
// // // // //     );
// // // // //     if (time == null) return;
// // // // //     setState(() {
// // // // //       _timestamp =
// // // // //           DateTime(date.year, date.month, date.day, time.hour, time.minute);
// // // // //     });
// // // // //   }

// // // // //   Future<String?> _uploadImage(File file) async {
// // // // //     final user = FirebaseAuth.instance.currentUser!;
// // // // //     final path =
// // // // //         'meals/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
// // // // //     final ref = FirebaseStorage.instance.ref().child(path);
// // // // //     await ref.putFile(file);
// // // // //     return await ref.getDownloadURL();
// // // // //   }

// // // // //   Future<void> _saveMeal() async {
// // // // //     if (!_formKey.currentState!.validate()) return;
// // // // //     setState(() {
// // // // //       _isSaving = true;
// // // // //     });
// // // // //     try {
// // // // //       final user = FirebaseAuth.instance.currentUser!;
// // // // //       String? imageUrl = _photoUrl;
// // // // //       if (_imageFile != null) {
// // // // //         imageUrl = await _uploadImage(_imageFile!);
// // // // //       }
// // // // //       final meal = Meal(
// // // // //         id: widget.existingMeal?.id ?? '',
// // // // //         userId: user.uid,
// // // // //         type: _type!,
// // // // //         title: _titleController.text.trim(),
// // // // //         description: _descController.text.trim(),
// // // // //         quantity: int.tryParse(_quantityController.text),
// // // // //         calories: int.tryParse(_caloriesController.text),
// // // // //         protein: int.tryParse(_proteinController.text),
// // // // //         carbs: int.tryParse(_carbsController.text),
// // // // //         fats: int.tryParse(_fatsController.text),
// // // // //         timestamp: _timestamp,
// // // // //         photoUrl: imageUrl,
// // // // //       );
// // // // //       final service = FirestoreService();
// // // // //       if (widget.existingMeal == null) {
// // // // //         await service.addMeal(meal);
// // // // //       } else {
// // // // //         await service.updateMeal(meal);
// // // // //       }
// // // // //       if (mounted) Navigator.pop(context);
// // // // //     } catch (e) {
// // // // //       ScaffoldMessenger.of(context)
// // // // //           .showSnackBar(SnackBar(content: Text('Error saving meal: \$e')));
// // // // //     } finally {
// // // // //       if (mounted)
// // // // //         setState(() {
// // // // //           _isSaving = false;
// // // // //         });
// // // // //     }
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: Text(widget.existingMeal == null ? 'Add Meal' : 'Edit Meal'),
// // // // //       ),
// // // // //       body: SingleChildScrollView(
// // // // //         padding: const EdgeInsets.all(16),
// // // // //         child: Form(
// // // // //           key: _formKey,
// // // // //           child: Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // //             children: [
// // // // //               DropdownButtonFormField<String>(
// // // // //                 value: _type,
// // // // //                 decoration: const InputDecoration(labelText: 'Meal Type'),
// // // // //                 items: _types
// // // // //                     .map((t) => DropdownMenuItem(value: t, child: Text(t)))
// // // // //                     .toList(),
// // // // //                 onChanged: (v) => setState(() {
// // // // //                   _type = v;
// // // // //                 }),
// // // // //                 validator: (v) =>
// // // // //                     v == null ? 'Please select a meal type.' : null,
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               TextFormField(
// // // // //                 controller: _titleController,
// // // // //                 decoration: const InputDecoration(labelText: 'Title'),
// // // // //                 maxLength: 100,
// // // // //                 validator: (v) =>
// // // // //                     v == null || v.isEmpty ? 'Enter a title.' : null,
// // // // //               ),
// // // // //               TextFormField(
// // // // //                 controller: _descController,
// // // // //                 decoration: const InputDecoration(labelText: 'Description'),
// // // // //                 maxLength: 300,
// // // // //                 maxLines: 3,
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               TextFormField(
// // // // //                 controller: _quantityController,
// // // // //                 decoration: const InputDecoration(labelText: 'Quantity'),
// // // // //                 keyboardType: TextInputType.number,
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               TextFormField(
// // // // //                 controller: _caloriesController,
// // // // //                 decoration:
// // // // //                     const InputDecoration(labelText: 'Calories (optional)'),
// // // // //                 keyboardType: TextInputType.number,
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               Row(
// // // // //                 children: [
// // // // //                   Expanded(
// // // // //                     child: TextFormField(
// // // // //                       controller: _proteinController,
// // // // //                       decoration:
// // // // //                           const InputDecoration(labelText: 'Protein (g)'),
// // // // //                       keyboardType: TextInputType.number,
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 8),
// // // // //                   Expanded(
// // // // //                     child: TextFormField(
// // // // //                       controller: _carbsController,
// // // // //                       decoration: const InputDecoration(labelText: 'Carbs (g)'),
// // // // //                       keyboardType: TextInputType.number,
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 8),
// // // // //                   Expanded(
// // // // //                     child: TextFormField(
// // // // //                       controller: _fatsController,
// // // // //                       decoration: const InputDecoration(labelText: 'Fats (g)'),
// // // // //                       keyboardType: TextInputType.number,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               TextButton(
// // // // //                 onPressed: _selectDateTime,
// // // // //                 child: Text('Time: \${_timestamp.toLocal()}'.split('.')[0]),
// // // // //               ),
// // // // //               const SizedBox(height: 12),
// // // // //               if (_photoUrl != null)
// // // // //                 Image.network(_photoUrl!, height: 150, fit: BoxFit.cover),
// // // // //               if (_imageFile != null)
// // // // //                 Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
// // // // //               TextButton.icon(
// // // // //                 onPressed: _pickImage,
// // // // //                 icon: const Icon(Icons.camera_alt),
// // // // //                 label: const Text('Capture Photo'),
// // // // //               ),
// // // // //               const SizedBox(height: 20),
// // // // //               ElevatedButton(
// // // // //                 onPressed: _isSaving ? null : _saveMeal,
// // // // //                 child: _isSaving
// // // // //                     ? const CircularProgressIndicator()
// // // // //                     : const Text('Save'),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // lib/screens/add_edit_meal_page.dart
// // // // import 'dart:io';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:image_picker/image_picker.dart';
// // // // import 'package:firebase_storage/firebase_storage.dart';
// // // // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // // // import 'package:meal_tracker_flutter/models/meals_models.dart';

// // // // class AddEditMealPage extends StatefulWidget {
// // // //   final Meal? existingMeal;
// // // //   const AddEditMealPage({Key? key, this.existingMeal}) : super(key: key);

// // // //   @override
// // // //   _AddEditMealPageState createState() => _AddEditMealPageState();
// // // // }

// // // // class _AddEditMealPageState extends State<AddEditMealPage> {
// // // //   final _formKey = GlobalKey<FormState>();
// // // //   final _types = ['Breakfast', 'Lunch', 'Dinner'];
// // // //   String? _type;
// // // //   final _titleController = TextEditingController();
// // // //   final _descController = TextEditingController();
// // // //   final _quantityController = TextEditingController();
// // // //   final _caloriesController = TextEditingController();
// // // //   final _proteinController = TextEditingController();
// // // //   final _carbsController = TextEditingController();
// // // //   final _fatsController = TextEditingController();
// // // //   DateTime _timestamp = DateTime.now();
// // // //   File? _imageFile;
// // // //   String? _photoUrl;
// // // //   bool _isSaving = false;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     final m = widget.existingMeal;
// // // //     if (m != null) {
// // // //       _type = m.type;
// // // //       _titleController.text = m.title;
// // // //       _descController.text = m.description;
// // // //       _quantityController.text = m.quantity?.toString() ?? '';
// // // //       _caloriesController.text = m.calories?.toString() ?? '';
// // // //       _proteinController.text = m.protein?.toString() ?? '';
// // // //       _carbsController.text = m.carbs?.toString() ?? '';
// // // //       _fatsController.text = m.fats?.toString() ?? '';
// // // //       _timestamp = m.timestamp;
// // // //       _photoUrl = m.photoUrl;
// // // //     }
// // // //   }

// // // //   Future<void> _pickImage() async {
// // // //     final picker = ImagePicker();
// // // //     final picked = await picker.pickImage(source: ImageSource.camera);
// // // //     if (picked != null) {
// // // //       setState(() {
// // // //         _imageFile = File(picked.path);
// // // //       });
// // // //     }
// // // //   }

// // // //   Future<void> _selectDateTime() async {
// // // //     final date = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: _timestamp,
// // // //       firstDate: DateTime(2000),
// // // //       lastDate: DateTime.now(),
// // // //     );
// // // //     if (date == null) return;
// // // //     final time = await showTimePicker(
// // // //       context: context,
// // // //       initialTime: TimeOfDay.fromDateTime(_timestamp),
// // // //     );
// // // //     if (time == null) return;
// // // //     setState(() {
// // // //       _timestamp = DateTime(
// // // //         date.year,
// // // //         date.month,
// // // //         date.day,
// // // //         time.hour,
// // // //         time.minute,
// // // //       );
// // // //     });
// // // //   }

// // // //   Future<String?> _uploadImage(File file) async {
// // // //     final user = FirebaseAuth.instance.currentUser!;
// // // //     final path =
// // // //         'meals/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
// // // //     final ref = FirebaseStorage.instance.ref().child(path);
// // // //     await ref.putFile(file);
// // // //     return await ref.getDownloadURL();
// // // //   }

// // // //   Future<void> _saveMeal() async {
// // // //     if (!_formKey.currentState!.validate()) return;
// // // //     setState(() {
// // // //       _isSaving = true;
// // // //     });
// // // //     try {
// // // //       final user = FirebaseAuth.instance.currentUser!;
// // // //       String? imageUrl = _photoUrl;
// // // //       if (_imageFile != null) {
// // // //         imageUrl = await _uploadImage(_imageFile!);
// // // //       }
// // // //       final meal = Meal(
// // // //         id: widget.existingMeal?.id ?? '',
// // // //         userId: user.uid,
// // // //         type: _type!,
// // // //         title: _titleController.text.trim(),
// // // //         description: _descController.text.trim(),
// // // //         quantity: int.tryParse(_quantityController.text),
// // // //         calories: int.tryParse(_caloriesController.text),
// // // //         protein: int.tryParse(_proteinController.text),
// // // //         carbs: int.tryParse(_carbsController.text),
// // // //         fats: int.tryParse(_fatsController.text),
// // // //         timestamp: _timestamp,
// // // //         photoUrl: imageUrl,
// // // //       );
// // // //       final service = FirestoreService();
// // // //       if (widget.existingMeal == null) {
// // // //         await service.addMeal(meal);
// // // //       } else {
// // // //         await service.updateMeal(meal);
// // // //       }
// // // //       if (mounted) Navigator.pop(context);
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text('Error saving meal: \$e')),
// // // //       );
// // // //     } finally {
// // // //       if (mounted)
// // // //         setState(() {
// // // //           _isSaving = false;
// // // //         });
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: Text(
// // // //           widget.existingMeal == null ? 'Add Meal' : 'Edit Meal',
// // // //         ),
// // // //       ),
// // // //       body: SingleChildScrollView(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Form(
// // // //           key: _formKey,
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // // //             children: [
// // // //               DropdownButtonFormField<String>(
// // // //                 value: _type,
// // // //                 decoration: const InputDecoration(labelText: 'Meal Type'),
// // // //                 items: _types.map((t) {
// // // //                   return DropdownMenuItem(
// // // //                     value: t,
// // // //                     child: Text(t),
// // // //                   );
// // // //                 }).toList(),
// // // //                 onChanged: (v) => setState(() {
// // // //                   _type = v;
// // // //                 }),
// // // //                 validator: (v) =>
// // // //                     v == null ? 'Please select a meal type.' : null,
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               TextFormField(
// // // //                 controller: _titleController,
// // // //                 decoration: const InputDecoration(labelText: 'Title'),
// // // //                 maxLength: 100,
// // // //                 validator: (v) =>
// // // //                     v == null || v.isEmpty ? 'Enter a title.' : null,
// // // //               ),
// // // //               TextFormField(
// // // //                 controller: _descController,
// // // //                 decoration: const InputDecoration(labelText: 'Description'),
// // // //                 maxLength: 300,
// // // //                 maxLines: 3,
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               TextFormField(
// // // //                 controller: _quantityController,
// // // //                 decoration: const InputDecoration(labelText: 'Quantity'),
// // // //                 keyboardType: TextInputType.number,
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               TextFormField(
// // // //                 controller: _caloriesController,
// // // //                 decoration:
// // // //                     const InputDecoration(labelText: 'Calories (optional)'),
// // // //                 keyboardType: TextInputType.number,
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               Row(
// // // //                 children: [
// // // //                   Expanded(
// // // //                     child: TextFormField(
// // // //                       controller: _proteinController,
// // // //                       decoration:
// // // //                           const InputDecoration(labelText: 'Protein (g)'),
// // // //                       keyboardType: TextInputType.number,
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 8),
// // // //                   Expanded(
// // // //                     child: TextFormField(
// // // //                       controller: _carbsController,
// // // //                       decoration: const InputDecoration(labelText: 'Carbs (g)'),
// // // //                       keyboardType: TextInputType.number,
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 8),
// // // //                   Expanded(
// // // //                     child: TextFormField(
// // // //                       controller: _fatsController,
// // // //                       decoration: const InputDecoration(labelText: 'Fats (g)'),
// // // //                       keyboardType: TextInputType.number,
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               TextButton(
// // // //                 onPressed: _selectDateTime,
// // // //                 child: Text(
// // // //                   'Time: ${_timestamp.toLocal()}',
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 12),
// // // //               if (_photoUrl != null)
// // // //                 Image.network(_photoUrl!, height: 150, fit: BoxFit.cover),
// // // //               if (_imageFile != null)
// // // //                 Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
// // // //               TextButton.icon(
// // // //                 onPressed: _pickImage,
// // // //                 icon: const Icon(Icons.camera_alt),
// // // //                 label: const Text('Capture Photo'),
// // // //               ),
// // // //               const SizedBox(height: 20),
// // // //               ElevatedButton(
// // // //                 onPressed: _isSaving ? null : _saveMeal,
// // // //                 child: _isSaving
// // // //                     ? const CircularProgressIndicator()
// // // //                     : const Text('Save'),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // lib/screens/add_edit_meal_page.dart
// // // import 'dart:io';
// // // import 'package:flutter/material.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:firebase_storage/firebase_storage.dart';
// // // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // // import 'package:meal_tracker_flutter/models/meals_models.dart';

// // // class AddEditMealPage extends StatefulWidget {
// // //   final Meal? existingMeal;
// // //   const AddEditMealPage({Key? key, this.existingMeal}) : super(key: key);

// // //   @override
// // //   _AddEditMealPageState createState() => _AddEditMealPageState();
// // // }

// // // class _AddEditMealPageState extends State<AddEditMealPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   final _types = ['Breakfast', 'Lunch', 'Dinner'];
// // //   String? _type;
// // //   final _titleController = TextEditingController();
// // //   final _descController = TextEditingController();
// // //   final _quantityController = TextEditingController();
// // //   final _caloriesController = TextEditingController();
// // //   final _proteinController = TextEditingController();
// // //   final _carbsController = TextEditingController();
// // //   final _fatsController = TextEditingController();
// // //   DateTime _timestamp = DateTime.now();
// // //   File? _imageFile;
// // //   String? _photoUrl;
// // //   bool _isSaving = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     final m = widget.existingMeal;
// // //     if (m != null) {
// // //       _type = m.type;
// // //       _titleController.text = m.title;
// // //       _descController.text = m.description;
// // //       _quantityController.text = m.quantity?.toString() ?? '';
// // //       _caloriesController.text = m.calories?.toString() ?? '';
// // //       _proteinController.text = m.protein?.toString() ?? '';
// // //       _carbsController.text = m.carbs?.toString() ?? '';
// // //       _fatsController.text = m.fats?.toString() ?? '';
// // //       _timestamp = m.timestamp;
// // //       _photoUrl = m.photoUrl;
// // //     }
// // //   }

// // //   Future<void> _pickImage() async {
// // //     final picker = ImagePicker();
// // //     final picked = await picker.pickImage(source: ImageSource.camera);
// // //     if (picked != null) {
// // //       setState(() {
// // //         _imageFile = File(picked.path);
// // //       });
// // //     }
// // //   }

// // //   Future<void> _selectDateTime() async {
// // //     final date = await showDatePicker(
// // //       context: context,
// // //       initialDate: _timestamp,
// // //       firstDate: DateTime(2000),
// // //       lastDate: DateTime.now(),
// // //     );
// // //     if (date == null) return;
// // //     final time = await showTimePicker(
// // //       context: context,
// // //       initialTime: TimeOfDay.fromDateTime(_timestamp),
// // //     );
// // //     if (time == null) return;
// // //     setState(() {
// // //       _timestamp = DateTime(
// // //         date.year,
// // //         date.month,
// // //         date.day,
// // //         time.hour,
// // //         time.minute,
// // //       );
// // //     });
// // //   }

// // //   Future<String?> _uploadImage(File file) async {
// // //     final user = FirebaseAuth.instance.currentUser!;
// // //     final path = 'meals/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
// // //     final ref = FirebaseStorage.instance.ref().child(path);
// // //     await ref.putFile(file);
// // //     return await ref.getDownloadURL();
// // //   }

// // //   Future<void> _saveMeal() async {
// // //     if (!_formKey.currentState!.validate()) return;
// // //     setState(() {
// // //       _isSaving = true;
// // //     });
// // //     try {
// // //       final user = FirebaseAuth.instance.currentUser!;
// // //       String? imageUrl = _photoUrl;
// // //       if (_imageFile != null) {
// // //         imageUrl = await _uploadImage(_imageFile!);
// // //       }
// // //       final meal = Meal(
// // //         id: widget.existingMeal?.id ?? '',
// // //         userId: user.uid,
// // //         type: _type!,
// // //         title: _titleController.text.trim(),
// // //         description: _descController.text.trim(),
// // //         quantity: int.tryParse(_quantityController.text),
// // //         calories: int.tryParse(_caloriesController.text),
// // //         protein: int.tryParse(_proteinController.text),
// // //         carbs: int.tryParse(_carbsController.text),
// // //         fats: int.tryParse(_fatsController.text),
// // //         timestamp: _timestamp,
// // //         photoUrl: imageUrl,
// // //       );
// // //       final service = FirestoreService();
// // //       if (widget.existingMeal == null) {
// // //         await service.addMeal(meal);
// // //       } else {
// // //         await service.updateMeal(meal);
// // //       }
// // //       if (mounted) Navigator.pop(context);
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Error saving meal: \$e')),
// // //       );
// // //     } finally {
// // //       if (mounted) setState(() {
// // //         _isSaving = false;
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text(
// // //           widget.existingMeal == null ? 'Add Meal' : 'Edit Meal',
// // //         ),
// // //       ),
// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(16),
// // //         child: Form(
// // //           key: _formKey,
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.stretch,
// // //             children: [
// // //               DropdownButtonFormField<String>(
// // //                 value: _type,
// // //                 decoration: const InputDecoration(labelText: 'Meal Type'),
// // //                 items: _types.map((t) {
// // //                   return DropdownMenuItem(
// // //                     value: t,
// // //                     child: Text(t),
// // //                   );
// // //                 }).toList(),
// // //                 onChanged: (v) => setState(() {
// // //                   _type = v;
// // //                 }),
// // //                 validator: (v) => v == null ? 'Please select a meal type.' : null,
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _titleController,
// // //                 decoration: const InputDecoration(labelText: 'Title'),
// // //                 maxLength: 100,
// // //                 validator: (v) => v == null || v.isEmpty ? 'Enter a title.' : null,
// // //               ),
// // //               TextFormField(
// // //                 controller: _descController,
// // //                 decoration: const InputDecoration(labelText: 'Description'),
// // //                 maxLength: 300,
// // //                 maxLines: 3,
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _quantityController,
// // //                 decoration: const InputDecoration(labelText: 'Quantity'),
// // //                 keyboardType: TextInputType.number,
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextFormField(
// // //                 controller: _caloriesController,
// // //                 decoration: const InputDecoration(labelText: 'Calories (optional)'),
// // //                 keyboardType: TextInputType.number,
// // //               ),
// // //               const SizedBox(height: 12),
// // //               Row(
// // //                 children: [
// // //                   Expanded(
// // //                     child: TextFormField(
// // //                       controller: _proteinController,
// // //                       decoration: const InputDecoration(labelText: 'Protein (g)'),
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   Expanded(
// // //                     child: TextFormField(
// // //                       controller: _carbsController,
// // //                       decoration: const InputDecoration(labelText: 'Carbs (g)'),
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   Expanded(
// // //                     child: TextFormField(
// // //                       controller: _fatsController,
// // //                       decoration: const InputDecoration(labelText: 'Fats (g)'),
// // //                       keyboardType: TextInputType.number,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 12),
// // //               TextButton(
// // //                 onPressed: _selectDateTime,
// // //                 child: Text(
// // //                   'Time: ${_timestamp.toLocal()}',
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               if (_photoUrl != null) Image.network(_photoUrl!, height: 150, fit: BoxFit.cover),
// // //               if (_imageFile != null) Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
// // //               TextButton.icon(
// // //                 onPressed: _pickImage,
// // //                 icon: const Icon(Icons.camera_alt),
// // //                 label: const Text('Capture Photo'),
// // //               ),
// // //               const SizedBox(height: 20),
// // //               ElevatedButton(
// // //                 onPressed: _isSaving ? null : _saveMeal,
// // //                 child: _isSaving
// // //                   ? const CircularProgressIndicator()
// // //                   : const Text('Save'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // // lib/screens/add_edit_meal_page.dart
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// // import 'package:meal_tracker_flutter/models/meals_models.dart';

// // class AddEditMealPage extends StatefulWidget {
// //   final Meal? existingMeal;
// //   const AddEditMealPage({Key? key, this.existingMeal}) : super(key: key);

// //   @override
// //   _AddEditMealPageState createState() => _AddEditMealPageState();
// // }

// // class _AddEditMealPageState extends State<AddEditMealPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   final _types = ['Breakfast', 'Lunch', 'Dinner'];
// //   String? _type;
// //   final _titleController = TextEditingController();
// //   final _descController = TextEditingController();
// //   final _quantityController = TextEditingController();
// //   final _caloriesController = TextEditingController();
// //   final _proteinController = TextEditingController();
// //   final _carbsController = TextEditingController();
// //   final _fatsController = TextEditingController();
// //   DateTime _timestamp = DateTime.now();
// //   File? _imageFile;
// //   String? _photoUrl;
// //   bool _isSaving = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     final m = widget.existingMeal;
// //     if (m != null) {
// //       _type = m.type;
// //       _titleController.text = m.title;
// //       _descController.text = m.description;
// //       _quantityController.text = m.quantity?.toString() ?? '';
// //       _caloriesController.text = m.calories?.toString() ?? '';
// //       _proteinController.text = m.protein?.toString() ?? '';
// //       _carbsController.text = m.carbs?.toString() ?? '';
// //       _fatsController.text = m.fats?.toString() ?? '';
// //       _timestamp = m.timestamp;
// //       _photoUrl = m.photoUrl;
// //     }
// //   }

// //   Future<void> _pickImage() async {
// //     final picker = ImagePicker();
// //     final picked = await picker.pickImage(source: ImageSource.camera);
// //     if (picked != null) setState(() => _imageFile = File(picked.path));
// //   }

// //   Future<void> _selectDateTime() async {
// //     final date = await showDatePicker(
// //       context: context,
// //       initialDate: _timestamp,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime.now(),
// //     );
// //     if (date == null) return;
// //     final time = await showTimePicker(
// //       context: context,
// //       initialTime: TimeOfDay.fromDateTime(_timestamp),
// //     );
// //     if (time == null) return;
// //     setState(() {
// //       _timestamp = DateTime(
// //         date.year,
// //         date.month,
// //         date.day,
// //         time.hour,
// //         time.minute,
// //       );
// //     });
// //   }

// //   Future<String?> _uploadImage(File file) async {
// //     final user = FirebaseAuth.instance.currentUser!;
// //     final path =
// //         'meals/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
// //     final ref = FirebaseStorage.instance.ref().child(path);
// //     await ref.putFile(file);
// //     return await ref.getDownloadURL();
// //   }

// //   Future<void> _saveMeal() async {
// //     if (!_formKey.currentState!.validate()) return;
// //     setState(() => _isSaving = true);
// //     try {
// //       final user = FirebaseAuth.instance.currentUser!;
// //       String? imageUrl = _photoUrl;
// //       if (_imageFile != null) imageUrl = await _uploadImage(_imageFile!);
// //       final meal = Meal(
// //         id: widget.existingMeal?.id ?? '',
// //         userId: user.uid,
// //         type: _type!,
// //         title: _titleController.text.trim(),
// //         description: _descController.text.trim(),
// //         quantity: int.tryParse(_quantityController.text),
// //         calories: int.tryParse(_caloriesController.text),
// //         protein: int.tryParse(_proteinController.text),
// //         carbs: int.tryParse(_carbsController.text),
// //         fats: int.tryParse(_fatsController.text),
// //         timestamp: _timestamp,
// //         photoUrl: imageUrl,
// //       );
// //       final service = FirestoreService();
// //       if (widget.existingMeal == null)
// //         await service.addMeal(meal);
// //       else
// //         await service.updateMeal(meal);
// //       if (mounted) Navigator.pop(context);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error saving meal: $e')),
// //       );
// //     } finally {
// //       if (mounted) setState(() => _isSaving = false);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.existingMeal == null ? 'Add Meal' : 'Edit Meal'),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               DropdownButtonFormField<String>(
// //                 value: _type,
// //                 decoration: const InputDecoration(labelText: 'Meal Type'),
// //                 items: _types
// //                     .map((t) => DropdownMenuItem(value: t, child: Text(t)))
// //                     .toList(),
// //                 onChanged: (v) => setState(() => _type = v),
// //                 validator: (v) =>
// //                     v == null ? 'Please select a meal type.' : null,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _titleController,
// //                 decoration: const InputDecoration(labelText: 'Title'),
// //                 maxLength: 100,
// //                 validator: (v) =>
// //                     v == null || v.isEmpty ? 'Enter a title.' : null,
// //               ),
// //               TextFormField(
// //                 controller: _descController,
// //                 decoration: const InputDecoration(labelText: 'Description'),
// //                 maxLength: 300,
// //                 maxLines: 3,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _quantityController,
// //                 decoration: const InputDecoration(labelText: 'Quantity'),
// //                 keyboardType: TextInputType.number,
// //               ),
// //               const SizedBox(height: 12),
// //               TextFormField(
// //                 controller: _caloriesController,
// //                 decoration:
// //                     const InputDecoration(labelText: 'Calories (optional)'),
// //                 keyboardType: TextInputType.number,
// //               ),
// //               const SizedBox(height: 12),
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextFormField(
// //                       controller: _proteinController,
// //                       decoration:
// //                           const InputDecoration(labelText: 'Protein (g)'),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     child: TextFormField(
// //                       controller: _carbsController,
// //                       decoration: const InputDecoration(labelText: 'Carbs (g)'),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Expanded(
// //                     child: TextFormField(
// //                       controller: _fatsController,
// //                       decoration: const InputDecoration(labelText: 'Fats (g)'),
// //                       keyboardType: TextInputType.number,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               TextButton(
// //                 onPressed: _selectDateTime,
// //                 child: Text('Time: ${_timestamp.toLocal()}'.split('.')[0]),
// //               ),
// //               const SizedBox(height: 12),
// //               if (_photoUrl != null)
// //                 Image.network(_photoUrl!, height: 150, fit: BoxFit.cover),
// //               if (_imageFile != null)
// //                 Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
// //               TextButton.icon(
// //                 onPressed: _pickImage,
// //                 icon: const Icon(Icons.camera_alt),
// //                 label: const Text('Capture Photo'),
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _isSaving ? null : _saveMeal,
// //                 child: _isSaving
// //                     ? const CircularProgressIndicator()
// //                     : const Text('Save'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // lib/views/add_edit_meal_page.dart

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:meal_tracker_flutter/helpers/firestore_service.dart';
// import 'package:meal_tracker_flutter/models/meals_models.dart';

// class AddEditMealPage extends StatefulWidget {
//   /// If `meal` is null, we’re adding a new entry; otherwise we’re editing.
//   final Meal? meal;
//   const AddEditMealPage({Key? key, this.meal}) : super(key: key);

//   @override
//   _AddEditMealPageState createState() => _AddEditMealPageState();
// }

// class _AddEditMealPageState extends State<AddEditMealPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for form fields
//   final _titleCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _quantityCtrl = TextEditingController();
//   final _caloriesCtrl = TextEditingController();
//   final _proteinCtrl = TextEditingController();
//   final _carbsCtrl = TextEditingController();
//   final _fatsCtrl = TextEditingController();

//   // State
//   String _selectedType = 'Breakfast';
//   DateTime _selectedDateTime = DateTime.now();
//   XFile? _pickedImage;
//   String? _photoUrl;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // If editing, populate fields
//     final m = widget.meal;
//     if (m != null) {
//       _selectedType = m.type;
//       _titleCtrl.text = m.title;
//       _descCtrl.text = m.description;
//       _selectedDateTime = m.timestamp;
//       if (m.quantity != null) _quantityCtrl.text = m.quantity.toString();
//       if (m.calories != null) _caloriesCtrl.text = m.calories.toString();
//       if (m.protein != null) _proteinCtrl.text = m.protein.toString();
//       if (m.carbs != null) _carbsCtrl.text = m.carbs.toString();
//       if (m.fats != null) _fatsCtrl.text = m.fats.toString();
//       _photoUrl = m.photoUrl;
//     }
//   }

//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _descCtrl.dispose();
//     _quantityCtrl.dispose();
//     _caloriesCtrl.dispose();
//     _proteinCtrl.dispose();
//     _carbsCtrl.dispose();
//     _fatsCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: source, imageQuality: 85);
//     if (picked != null) {
//       setState(() => _pickedImage = picked);
//     }
//   }

//   Future<void> _selectDateTime() async {
//     final date = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime,
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (date == null) return;

//     final time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
//     );
//     if (time == null) return;

//     setState(() {
//       _selectedDateTime =
//           DateTime(date.year, date.month, date.day, time.hour, time.minute);
//     });
//   }

//   Future<void> _saveMeal() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       String? photoUrl = _photoUrl;

//       // Upload image if user picked one
//       if (_pickedImage != null) {
//         final file = File(_pickedImage!.path);
//         final path =
//             'meals/$uid/${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}';
//         final ref = FirebaseStorage.instance.ref().child(path);
//         final snap = await ref.putFile(file);
//         photoUrl = await snap.ref.getDownloadURL();
//       }

//       // Build Meal object
//       final meal = Meal(
//         id: widget.meal?.id ?? '',
//         userId: uid,
//         type: _selectedType,
//         title: _titleCtrl.text.trim(),
//         description: _descCtrl.text.trim(),
//         quantity: int.tryParse(_quantityCtrl.text),
//         calories: int.tryParse(_caloriesCtrl.text),
//         protein: int.tryParse(_proteinCtrl.text),
//         carbs: int.tryParse(_carbsCtrl.text),
//         fats: int.tryParse(_fatsCtrl.text),
//         timestamp: _selectedDateTime,
//         photoUrl: photoUrl,
//       );

//       // Decide add vs update
//       if (widget.meal == null) {
//         await FirestoreService().addMeal(meal);
//         // Analytics: new meal event
//         await FirebaseAnalytics.instance.logEvent(
//           name: 'meal_added',
//           parameters: {
//             'type': meal.type,
//             'calories': meal.calories ?? 0,
//           },
//         );
//       } else {
//         await FirestoreService().updateMeal(meal);
//         // Analytics: updated meal event
//         await FirebaseAnalytics.instance.logEvent(
//           name: 'meal_updated',
//           parameters: {
//             'type': meal.type,
//             'calories': meal.calories ?? 0,
//           },
//         );
//       }

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving meal: $e')),
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = widget.meal == null ? 'Add Meal' : 'Edit Meal';

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Meal Type Dropdown
//                     DropdownButtonFormField<String>(
//                       value: _selectedType,
//                       items: ['Breakfast', 'Lunch', 'Dinner']
//                           .map(
//                               (t) => DropdownMenuItem(value: t, child: Text(t)))
//                           .toList(),
//                       onChanged: (v) => setState(() => _selectedType = v!),
//                       decoration: const InputDecoration(labelText: 'Meal Type'),
//                     ),
//                     const SizedBox(height: 16),
// // lib/views/add_edit_meal_page.dart
// // … inside your Form widget:

// TextFormField(
//   initialValue: widget.existingMeal?.title ?? '',
//   decoration: const InputDecoration(labelText: 'Title'),
//   maxLength: 100,
//   validator: (v) {
//     if (v == null || v.trim().isEmpty) return 'Title is required';
//     if (v.trim().length > 100) return 'Max 100 characters';
//     return null;
//   },
//   onSaved: (v) => meal.title = v!.trim(),
// ),

// TextFormField(
//   initialValue: widget.existingMeal?.description ?? '',
//   decoration: const InputDecoration(labelText: 'Description'),
//   maxLines: 3,
//   maxLength: 300,
//   validator: (v) {
//     if (v != null && v.length > 300) return 'Max 300 characters';
//     return null;
//   },
//   onSaved: (v) => meal.description = v?.trim(),
// ),

//                     // // Title
//                     // TextFormField(
//                     //   controller: _titleCtrl,
//                     //   decoration: const InputDecoration(
//                     //     labelText: 'Title',
//                     //     hintText: 'E.g. Avocado Toast',
//                     //   ),
//                     //   maxLength: 100,
//                     //   validator: (v) =>
//                     //       v != null && v.isNotEmpty ? null : 'Enter a title',
//                     // ),

//                     // // Description
//                     // TextFormField(
//                     //   controller: _descCtrl,
//                     //   decoration:
//                     //       const InputDecoration(labelText: 'Description'),
//                     //   maxLength: 300,
//                     //   validator: (v) => v != null && v.isNotEmpty
//                     //       ? null
//                     //       : 'Enter a description',
//                     // ),

//                     // Quantity
//                     TextFormField(
//                       controller: _quantityCtrl,
//                       decoration: const InputDecoration(
//                           labelText: 'Quantity / Portion Size'),
//                       keyboardType: TextInputType.number,
//                       validator: (v) =>
//                           v != null && v.isNotEmpty ? null : 'Enter quantity',
//                     ),

//                     // Optional Calories / Macros
//                     const SizedBox(height: 8),
//                     TextFormField(
//                       controller: _caloriesCtrl,
//                       decoration: const InputDecoration(
//                           labelText: 'Calories (optional)'),
//                       keyboardType: TextInputType.number,
//                     ),
//                     TextFormField(
//                       controller: _proteinCtrl,
//                       decoration: const InputDecoration(
//                           labelText: 'Protein (g, optional)'),
//                       keyboardType: TextInputType.number,
//                     ),
//                     TextFormField(
//                       controller: _carbsCtrl,
//                       decoration: const InputDecoration(
//                           labelText: 'Carbohydrates (g, optional)'),
//                       keyboardType: TextInputType.number,
//                     ),
//                     TextFormField(
//                       controller: _fatsCtrl,
//                       decoration: const InputDecoration(
//                           labelText: 'Fats (g, optional)'),
//                       keyboardType: TextInputType.number,
//                     ),

//                     const SizedBox(height: 16),
//                     // Date & Time Picker
//                     TextButton.icon(
//                       icon: const Icon(Icons.schedule),
//                       label: Text(
//                         'When: ${_selectedDateTime.year}/${_selectedDateTime.month.toString().padLeft(2, '0')}'
//                         ' ${_selectedDateTime.hour.toString().padLeft(2, '0')}:'
//                         '${_selectedDateTime.minute.toString().padLeft(2, '0')}',
//                       ),
//                       onPressed: _selectDateTime,
//                     ),

//                     const SizedBox(height: 16),
//                     // Image preview
//                     if (_pickedImage != null)
//                       Image.file(File(_pickedImage!.path), height: 200),
//                     if (_pickedImage == null && _photoUrl != null)
//                       Image.network(_photoUrl!, height: 200),

//                     const SizedBox(height: 8),
//                     // Pick Image Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.camera_alt),
//                           onPressed: () => _pickImage(ImageSource.camera),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.photo_library),
//                           onPressed: () => _pickImage(ImageSource.gallery),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 24),
//                     // Save Button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _saveMeal,
//                         child: Text(widget.meal == null ? 'Add Meal' : 'Save'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
// lib/views/add_edit_meal_page.dart

import 'package:flutter/material.dart';
import 'package:meal_tracker_flutter/helpers/firestore_service.dart';

import 'package:meal_tracker_flutter/models/meals_models.dart';

class AddEditMealPage extends StatefulWidget {
  final Meal? existingMeal;

  const AddEditMealPage({
    Key? key,
    this.existingMeal,
  }) : super(key: key);

  @override
  State<AddEditMealPage> createState() => _AddEditMealPageState();
}

class _AddEditMealPageState extends State<AddEditMealPage> {
  final _formKey = GlobalKey<FormState>();
  late Meal _meal;

  @override
  void initState() {
    super.initState();
    // If we got an existing meal, clone it, otherwise start a new one:
    _meal = widget.existingMeal != null
        ? widget.existingMeal!.copyWith()
        : Meal(
            type: 'Breakfast',
            title: '',
            description: '',
            portion: '',
            timestamp: DateTime.now(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingMeal == null ? 'Add Meal' : 'Edit Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field with validator, prefilled if editing
              TextFormField(
                initialValue: _meal.title,
                decoration: const InputDecoration(labelText: 'Title'),
                maxLength: 100,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Title is required';
                  return null;
                },
                onSaved: (v) => _meal = _meal.copyWith(title: v!.trim()),
              ),

              // Description field
              TextFormField(
                initialValue: _meal.description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                maxLength: 300,
                onSaved: (v) =>
                    _meal = _meal.copyWith(description: v?.trim() ?? ''),
              ),

              // TODO: the rest of your fields (type dropdown, portion, calories, macros, photo, timestamp)—
              // remember to use widget.existingMeal to prefill their initialValue/settings if editing

              const Spacer(),
              ElevatedButton(
                child: Text(
                    widget.existingMeal == null ? 'Add Meal' : 'Save Changes'),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  // then call FirestoreService to add or update:
                  if (widget.existingMeal == null) {
                    FirestoreService().addMeal(_meal);
                  } else {
                    FirestoreService().updateMeal(_meal);
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
