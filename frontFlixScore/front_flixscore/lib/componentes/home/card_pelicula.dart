import 'package:flixscore/componentes/common/snack_bar.dart';
import 'package:flixscore/componentes/home/components/resumen_pelicula.dart';
import 'package:flixscore/modelos/critica_modelo.dart';
import 'package:flixscore/modelos/pelicula_model.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flutter/material.dart';

class PeliculaCard extends StatelessWidget {
  final Pelicula pelicula;
  final ModeloCritica? critica;
  final ModeloUsuario? usuario;

  const PeliculaCard({super.key, required this.pelicula, this.critica, this.usuario});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => mostrarSnackBarExito(context, "Clickada ${pelicula.titulo}"),
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

  // Layout para grid (desktop/tablet)
  Widget _tarjetaLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                pelicula.rutaPoster,
                fit: BoxFit.cover),
              ),
            const SizedBox(width: 16),
            Expanded(child: ResumenPelicula(
              titulo: pelicula.titulo,
              resumen: pelicula.resumen,
              fechaEstreno: pelicula.fechaEstreno
            )),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF374151),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                usuario?.nick ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                critica?.comentario ?? "",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
