import 'package:flixscore/componentes/home/card_pelicula.dart';
import 'package:flixscore/modelos/critica_modelo.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flixscore/service/api_service.dart';
import 'package:flutter/foundation.dart';



class CriticasProvider extends ChangeNotifier{

  ModeloUsuario? _usuarioLogueado;
  ModeloUsuario? get usuarioLogueado => _usuarioLogueado;

  ApiService apiService = ApiService();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<ModeloCritica> _criticasUsuario = [];
  List<ModeloCritica> get criticasUsuario => _criticasUsuario;
  List<ModeloCritica> _criticasAmigos = [];
  List<ModeloCritica> get criticasAmigos => _criticasAmigos;
  List<PeliculaCard> _peliculasCardAmigos = [];
  List<PeliculaCard> get peliculasCardAmigos => _peliculasCardAmigos;
  
  CriticasProvider();

  //Metodo para actualizar el usuario logueado
  void actualizarUsuarioLogueado(ModeloUsuario? usuario) {
    _usuarioLogueado = usuario;
    _recargarUsuario();
  }

  Future<void> _recargarUsuario() async {
    await _cargarCriticasDelUsuario();
    await _cargarCriticasDeAmigos();
    await _servirPeliculasCard();
    notifyListeners();
  }

  Future<void> _cargarCriticasDelUsuario() async {
    if (_usuarioLogueado == null) {
      _errorMessage = "Usuario no logueado";
      notifyListeners();
      return;
    }


    try {
      _criticasUsuario = await apiService.getCriticasByUserId(_usuarioLogueado!.documentID!);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar críticas del usuario desde Provider $e";
    }
    notifyListeners();
  }

  Future<void> _cargarCriticasDeAmigos() async {
    if (_usuarioLogueado == null) {
      _errorMessage = "Usuario no logueado";
      notifyListeners();
      return;
    }

    List<ModeloCritica> criticasAmigosTemp = [];

    try {
      for (var amigoId in _usuarioLogueado!.amigosId) {
        List<ModeloCritica> criticasAmigo = await apiService.getCriticasByUserId(amigoId);
        criticasAmigosTemp.addAll(criticasAmigo);
      }
      _criticasAmigos = criticasAmigosTemp;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar críticas de amigos desde Provider: $e";
    }
    notifyListeners();
  }

  Future<void> _servirPeliculasCard() async {
    _peliculasCardAmigos.clear();
    try {
      for (var critica in _criticasAmigos) {
        var usuario = await apiService.getUsuarioByID(critica.usuarioUID);
        var pelicula = await apiService.getMovieByID(critica.peliculaID.toString());

        if (pelicula != null && usuario != null) {
        _peliculasCardAmigos.add(PeliculaCard(
          pelicula: pelicula,
          critica: critica,
          usuario: usuario,
        ));
      }
      }      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al servir películas de amigos desde Provider: $e";
    }
    notifyListeners();
  }
}