import 'package:flixscore/componentes/common/snack_bar.dart';
import 'package:flixscore/componentes/home/components/resumen_pelicula.dart';
import 'package:flixscore/modelos/critica_modelo.dart';
import 'package:flixscore/modelos/pelicula_modelo.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flutter/material.dart';

class PeliculaCard extends StatelessWidget {
  final ModeloPelicula pelicula;
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
        // Row(
        //   children: [
        //     Icon(
        //       Icons.comment,
        //       color: const Color.fromARGB(255, 252, 252, 252),
        //       size: 16,
        //     ),
        //     SizedBox(width: 6),
        //     Flexible(
        //       child: Text(
        //         "1 crítica",
        //         style: TextStyle(color: Colors.grey[400], fontSize: 14),
        //       ),
        //     ),
        //   ],
        // ),
        // Row(
        //   children: [
        //     Icon(
        //       Icons.calendar_month,
        //       color: const Color.fromARGB(255, 102, 102, 102),
        //       size: 16,
        //     ),
        //     SizedBox(width: 6),
        //     Flexible(
        //       child: Text(
        //         "25/10/2024",
        //         style: TextStyle(color: Colors.grey[400], fontSize: 14),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
