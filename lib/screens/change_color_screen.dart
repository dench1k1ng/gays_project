import 'package:flutter/material.dart';

class ChangeColorScreen extends StatefulWidget {
  final Color initialColor;

  const ChangeColorScreen({Key? key, required this.initialColor})
      : super(key: key);

  @override
  _ChangeColorScreenState createState() => _ChangeColorScreenState();
}

class _ChangeColorScreenState extends State<ChangeColorScreen> {
  Color _selectedColor = Colors.grey; // Default color

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  void _selectColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Выберите цвет")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // ✅ Show Selected Color
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _selectedColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 20),
          // ✅ Color Picker Buttons
          Wrap(
            spacing: 10,
            children: [
              _colorButton(Colors.blueAccent),
              _colorButton(Colors.greenAccent),
              _colorButton(Colors.orangeAccent),
              _colorButton(Colors.purpleAccent),
              _colorButton(Colors.redAccent),
              _colorButton(Colors.grey),
              _colorButton(Colors.brown),
            ],
          ),
          const SizedBox(height: 20),
          // ✅ Confirm Button
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _selectedColor);
            },
            child: const Text("Сохранить цвет"),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => _selectColor(color),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}
