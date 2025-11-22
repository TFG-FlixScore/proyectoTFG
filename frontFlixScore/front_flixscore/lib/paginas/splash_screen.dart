import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flixscore/controllers/criticas_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    final provider = Provider.of<CriticasProvider>(context, listen: false);
    await provider.cargarCriticasDelUsuario();
    await provider.cargarCriticasDeAmigos();
    await provider.servirPeliculasCard();
    await provider.cargarUltimasCriticas();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset('assets/images/animacion-splash.json'),
      ),
    );
  }
}