import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我的行事曆',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _itemNameController = TextEditingController();
  final List<String> _typeOptions = ['會議', '專案討論', '聯絡客戶'];
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();
  bool _isRdChecked = false;
  bool _isSalesChecked = false;
  bool _isFinanceChecked = false;
  bool _hasSubmitted = false;
  String _submittedItemName = '';
  String _submittedType = '';
  String _submittedDate = '';
  String _submittedDepartments = '';

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  void _showDatePicker() {
    Picker(
      adapter: DateTimePickerAdapter(
        type: PickerDateTimeType.kYMD,
        value: _selectedDate,
        minValue: DateTime(2000, 1, 1),
        maxValue: DateTime(2100, 12, 31),
      ),
      title: const Text('選擇日期'),
      onConfirm: (Picker picker, List<int> value) {
        final pickedDate = (picker.adapter as DateTimePickerAdapter).value;
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    ).showModal(context);
  }

  void _submitForm() {
    final departments = <String>[];
    if (_isRdChecked) departments.add('研發部');
    if (_isSalesChecked) departments.add('銷售部');
    if (_isFinanceChecked) departments.add('財務部');

    setState(() {
      _submittedItemName =
          _itemNameController.text.trim().isEmpty ? '未填寫' : _itemNameController.text.trim();
      _submittedType = _selectedType ?? '未選擇';
      _submittedDate = _formatDate(_selectedDate);
      _submittedDepartments = departments.isEmpty ? '未選擇' : departments.join('、');
      _hasSubmitted = true;
    });
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('我的行事曆'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: '項目名稱',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: '選擇類型',
                  border: OutlineInputBorder(),
                ),
                items: _typeOptions
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: '日期',
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDate(_selectedDate)),
                    TextButton(
                      onPressed: _showDatePicker,
                      child: const Text('設定日期'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: '相關部門',
                  border: OutlineInputBorder(),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('研發部'),
                      value: _isRdChecked,
                      onChanged: (value) {
                        setState(() {
                          _isRdChecked = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('銷售部'),
                      value: _isSalesChecked,
                      onChanged: (value) {
                        setState(() {
                          _isSalesChecked = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('財務部'),
                      value: _isFinanceChecked,
                      onChanged: (value) {
                        setState(() {
                          _isFinanceChecked = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('確定'),
                ),
              ),
              const SizedBox(height: 12),
              if (_hasSubmitted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('項目名稱：$_submittedItemName'),
                      Text('類型：$_submittedType'),
                      Text('日期：$_submittedDate'),
                      Text('相關部門：$_submittedDepartments'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
