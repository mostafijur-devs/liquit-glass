import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidMorphingDemo extends StatefulWidget {
  const LiquidMorphingDemo({super.key});

  @override
  State<LiquidMorphingDemo> createState() => _LiquidMorphingDemoState();
}

class _LiquidMorphingDemoState extends State<LiquidMorphingDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Offset> _positionAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Size Animation (bubble থেকে বড় liquid panel এ রূপান্তর)
    _sizeAnimation = Tween<double>(begin: 80.0, end: 280.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Position Animation
    _positionAnimation = Tween<Offset>(
      begin: const Offset(40, 550), // bottom-left position
      end: const Offset(40, 200), // upper-left position
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  void _toggleAnimation() {
    setState(() {
      if (_isExpanded) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isExpanded = !_isExpanded;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Main Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0f2027), Color(0xFF203a43), Color(0xFF2c5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Morphing Liquid Bubble
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left: _positionAnimation.value.dx,
                top: _positionAnimation.value.dy,
                child: GestureDetector(
                  onTap: _toggleAnimation,
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: Radius.circular(_isExpanded ? 40 : 100)
                    ),
                    settings: const LiquidGlassSettings(
                      thickness: 30,
                      glassColor: Color.fromARGB(80, 255, 255, 255),
                      lightIntensity: 1.2,
                      blend: 35,
                      chromaticAberration: 0.9,
                    ),
                    child: Container(
                      width: _sizeAnimation.value,
                      height: _sizeAnimation.value * 0.6,
                      alignment: Alignment.center,
                      child: _isExpanded
                          ? const Text(
                        "Dynamic Liquid Panel",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.flutter_dash,
                          color: Colors.white, size: 40),
                    ),
                  ),
                ),
              );
            },
          ),

          // Instruction Text
          const Positioned(
            left: 20,
            top: 40,
            child: Text(
              "Tap the bubble to morph",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
