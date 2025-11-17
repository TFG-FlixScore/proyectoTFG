// perfil_amigo_page.dart
import 'package:cached_network_image/cached_network_image.dart';
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
    required this.nickUsuario
  });

  Future<ModeloUsuario> _cargarUsuario() async {
    return await ApiService().getUsuarioByID(usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de $nickUsuario"),
        backgroundColor: const Color(0xFF111827),
      ),
      backgroundColor: const Color(0xFF0A0E1A),
      body: FutureBuilder<ModeloUsuario>(
        future: _cargarUsuario(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final usuario = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade700,
                    backgroundImage: (usuario.imagenPerfil?.isNotEmpty ?? false)
                        ? CachedNetworkImageProvider(usuario.imagenPerfil!)
                        : null,
                    child: (usuario.imagenPerfil?.isEmpty ?? true)
                        ? Text(
                            usuario.nick.isNotEmpty ? usuario.nick[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              fontSize: 20,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(usuario.nick, style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 20),
                  //EstadisticasCard(), // si la adapto a usuario externo
                  MisCriticasCard(usuarioId: usuarioId,  editable: false,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}