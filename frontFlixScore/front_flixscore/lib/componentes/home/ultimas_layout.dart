
import 'package:flixscore/componentes/home/card_pelicula.dart';
import 'package:flixscore/modelos/pelicula_model.dart';
import 'package:flixscore/service/api_service.dart';
import 'package:flutter/material.dart';

class UltimasLayout extends StatefulWidget {
  const UltimasLayout({super.key});

  @override
  State<UltimasLayout> createState() => _UltimasLayoutState();
}

class _UltimasLayoutState extends State<UltimasLayout> {

  final ApiService _apiService = ApiService();

  List<PeliculaCard> _peliculas = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarUltimasCriticas
    ();
  }

  Future<void> _cargarUltimasCriticas () async {
    try {
      setState(() {
        _cargando = true;
        _error = null;
      });

      final criticas = await _apiService.getCriticasRecientes(20);

      for (var critica in criticas) {

        var usuario = await _apiService.getUsuarioByID(critica.usuarioUID);
        var peliculaTmdb = await _apiService.getMovieByID(critica.peliculaID.toString());

        Pelicula pelicula = Pelicula(
          id: peliculaTmdb.id,
          titulo: peliculaTmdb.titulo,
          resumen: peliculaTmdb.resumen,
          fechaEstreno: peliculaTmdb.fechaEstreno,
          rutaPoster: peliculaTmdb.rutaPoster!,
        );

        _peliculas.add(PeliculaCard(critica: critica, pelicula: pelicula, usuario: usuario));
      }      



      setState(() {
        _peliculas = _peliculas;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: Colors.cyan));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar películas populares',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarUltimasCriticas
              ,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_peliculas.isEmpty) {
      return const Center(
        child: Text(
          "No hay películas populares disponibles",
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }


    return LayoutBuilder(
      builder: (context, constraints) {
        bool esMovil = constraints.maxWidth < 600;

        if (esMovil) {
          return _mostrarListView();
        } else {
          return _mostrarGridView(constraints);
        }
      },
    );
  }
  
  Widget _mostrarListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: _peliculas.length,
      itemBuilder: (context, index) {
        final pelicula = _peliculas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: pelicula,
        );
      },
    );
  }

  Widget _mostrarGridView(BoxConstraints constraints) {
    int columnas = constraints.maxWidth > 1000 ? 3 : 2;
    double anchoCard =
        (constraints.maxWidth - 60 - (20 * (columnas - 1))) / columnas;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: _peliculas.map((pelicula) {
          return SizedBox(
            width: anchoCard,
            child: pelicula
          );
        }).toList(),
      ),
    );
  }
}

