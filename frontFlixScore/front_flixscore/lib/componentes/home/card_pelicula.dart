import 'package:flixscore/componentes/common/tarjeta_pelicula_con_criticas.dart';
import 'package:flixscore/componentes/home/components/resumen_pelicula.dart';
import 'package:flixscore/modelos/critica_modelo.dart';
import 'package:flixscore/modelos/pelicula_modelo.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flutter/material.dart';

class PeliculaCard extends StatelessWidget {
  final ModeloPelicula pelicula;
  final ModeloCritica? critica;
  final ModeloUsuario? usuario;

  const PeliculaCard({
    super.key,
    required this.pelicula,
    this.critica,
    this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (critica != null) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: TarjetaPeliculaConCriticas(pelicula: pelicula),
                    ),
                  ),
                );
              }
            },
            child: Card(
              color: const Color(0xFF1F2937),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _tarjetaLayout(),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _tarjetaLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Imagen y puntuación
        Row(
          children: [
            Container(
              width: 140,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey,
              ),
              child: Image.network(
                pelicula.rutaPoster ?? '',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ResumenPelicula(
                titulo: pelicula.titulo,
                resumen: pelicula.resumen.length > 150
                    ? '${pelicula.resumen.substring(0, 150)}...'
                    : pelicula.resumen,
                fechaEstreno: pelicula.fechaEstreno,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 14),
            const SizedBox(width: 4),
            Text(
              "${critica?.puntuacion}/10",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
