import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FenerSayfasi extends StatefulWidget {
  const FenerSayfasi({super.key});

  @override
  State<FenerSayfasi> createState() => _FenerSayfasiState();
}

class _FenerSayfasiState extends State<FenerSayfasi> {
  bool _isOn = false;

  Future<void> _toggleFlashlight() async {
    try {
      if (_isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        _isOn = !_isOn;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Fener açma/kapama hatası: $e')));
    }
  }

  @override
  void dispose() {
    if (_isOn) {
      TorchLight.disableTorch();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('El Feneri'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: IconButton(
          iconSize: 120,
          icon: Icon(
            _isOn ? Icons.flashlight_on : Icons.flashlight_off,
            color: _isOn ? Colors.yellow : Colors.white,
          ),
          onPressed: _toggleFlashlight,
        ),
      ),
    );
  }
}
