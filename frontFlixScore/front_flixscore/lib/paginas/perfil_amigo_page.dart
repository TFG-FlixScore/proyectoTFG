import 'package:cached_network_image/cached_network_image.dart';
import 'package:flixscore/componentes/perfil_de_otro/amigos_de_otro_card.dart';
import 'package:flixscore/componentes/perfil_de_otro/estadisticas_otro_card.dart';
import 'package:flixscore/componentes/perfil_de_otro/imagen_perfil_otro_card.dart';
import 'package:flutter/material.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flixscore/service/api_service.dart';
import 'package:flixscore/componentes/perfil_usuario/mis_criticas_card.dart';

class PerfilAmigoPage extends StatelessWidget {
  final String usuarioId;
  final String nickUsuario;

  const PerfilAmigoPage({
    super.key,
    required this.usuarioId,
    required this.nickUsuario,
  });

  Future<ModeloUsuario> _cargarUsuario() async {
    return await ApiService().getUsuarioByID(usuarioId);
  }

  @override
  Widget build(BuildContext context) {

    const Color appBarColor = Color(0xFF111827); 
    const Color backgroundPage = Color(0xFF0A0E1A);

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de $nickUsuario"),
        automaticallyImplyLeading: true,
        toolbarHeight: 80,
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundPage,
      body: FutureBuilder<ModeloUsuario>(
        future: _cargarUsuario(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final usuario = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 600;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: isSmall
                      ? _buildOneColumnLayout(usuario)
                      : _buildTwoColumnLayout(usuario),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOneColumnLayout(
    ModeloUsuario usuario,
  ) {
    return Column(
      children: [
        FotoPerfilCualquierUsuario(usuarioId: usuarioId),
        const SizedBox(height: 10),
        EstadisticasAmigoCard(idAmigo: usuarioId),
        MisCriticasCard(usuarioId: usuarioId, editable: false),
        AmigosDeOtroCard(userId: usuarioId),
      ]
    );
  }

  Widget _buildTwoColumnLayout(
    ModeloUsuario usuario,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            children: [
              FotoPerfilCualquierUsuario(usuarioId: usuarioId),
              const SizedBox(height: 16),
              MisCriticasCard(usuarioId: usuarioId, editable: false),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              EstadisticasAmigoCard(idAmigo: usuarioId),
              const SizedBox(height: 15,),
              AmigosDeOtroCard(userId: usuarioId),
            ],
          ),
        ),
      ],
    );
  }
}