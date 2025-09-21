import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassDemo extends StatefulWidget {
  const LiquidGlassDemo({super.key});

  @override
  State<LiquidGlassDemo> createState() => _LiquidGlassDemoState();
}

class _LiquidGlassDemoState extends State<LiquidGlassDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animation controller for smooth motion
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ----------- Gradient Background with image blend -----------
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0f2027),
                  Color(0xFF203a43),
                  Color(0xFF2c5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.cover,
            ),
          ),

          // ----------- Multiple Liquid Glass UI -----------
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: _buildMainGlassCard(),
                    );
                  },
                ),
                const SizedBox(height: 40),
                _buildButtonRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Main Glass Card
  Widget _buildMainGlassCard() {
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: const Radius.circular(45)),

      settings: const LiquidGlassSettings(
        thickness: 30,
        glassColor: Color.fromARGB(70, 255, 255, 255),
        lightIntensity: 1.5,
        blend: 40,
        chromaticAberration: 1.2,
      ),
      child: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.flutter_dash, size: 70, color: Colors.white),
            SizedBox(height: 10),
            Text(
              "Liquid Glass Renderer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Interactive Glass Buttons
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlassButton(Icons.home, "Home", Colors.greenAccent),
        const SizedBox(width: 20),
        _buildGlassButton(Icons.settings, "Settings", Colors.pinkAccent),
        const SizedBox(width: 20),
        _buildGlassButton(Icons.person, "Profile", Colors.blueAccent),
      ],
    );
  }

  Widget _buildGlassButton(IconData icon, String label, Color highlightColor) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$label button pressed")),
        );
      },
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: const Radius.circular(20)),

        settings: LiquidGlassSettings(
          thickness: 20,
          glassColor: highlightColor.withOpacity(0.2),
          lightIntensity: 1.0,
          blend: 30,
          chromaticAberration: 0.6,
        ),
        child: SizedBox(
          width: 90,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
