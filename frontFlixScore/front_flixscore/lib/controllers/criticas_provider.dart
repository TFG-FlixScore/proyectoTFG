import 'package:flixscore/componentes/home/card_pelicula.dart';
import 'package:flixscore/modelos/critica_modelo.dart';
import 'package:flixscore/modelos/usuario_modelo.dart';
import 'package:flixscore/service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flixscore/utils/app_logger.dart';



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
    AppLogger.logMethod('actualizarUsuarioLogueado', message: 'usuario: $usuario');
    _usuarioLogueado = usuario;
    _recargarUsuario();
  }

  Future<void> _recargarUsuario() async {
    AppLogger.logMethod('_recargarUsuario', message: 'usuarioLogueado: $_usuarioLogueado');
    await _cargarCriticasDelUsuario();
    await _cargarCriticasDeAmigos();
    await _servirPeliculasCard();
    notifyListeners();
  }

  Future<void> _cargarCriticasDelUsuario() async {
    AppLogger.logMethod('_cargarCriticasDelUsuario', message: 'usuarioLogueado: $_usuarioLogueado');
    if (_usuarioLogueado == null) {
      _errorMessage = "Usuario no logueado";
      AppLogger.logError(_errorMessage!);
      notifyListeners();
      return;
    }

    try {
      _criticasUsuario = await apiService.getCriticasByUserId(_usuarioLogueado!.documentID!);
      AppLogger.logVar('criticasUsuario', _criticasUsuario);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar críticas del usuario desde Provider $e";
      AppLogger.logError(_errorMessage!);
    }
    notifyListeners();
  }

  Future<void> _cargarCriticasDeAmigos() async {
    AppLogger.logMethod('_cargarCriticasDeAmigos', message: 'usuarioLogueado: $_usuarioLogueado');
    if (_usuarioLogueado == null) {
      _errorMessage = "Usuario no logueado";
      AppLogger.logError(_errorMessage!);
      notifyListeners();
      return;
    }

    List<ModeloCritica> criticasAmigosTemp = [];

    try {
      for (var amigoId in _usuarioLogueado!.amigosId) {
        AppLogger.logVar('amigoId', amigoId);
        List<ModeloCritica> criticasAmigo = await apiService.getCriticasByUserId(amigoId);
        AppLogger.logVar('criticasAmigo', criticasAmigo);
        criticasAmigosTemp.addAll(criticasAmigo);
      }
      _criticasAmigos = criticasAmigosTemp;
      AppLogger.logVar('criticasAmigos', _criticasAmigos);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al cargar críticas de amigos desde Provider: $e";
      AppLogger.logError(_errorMessage!);
    }
    notifyListeners();
  }

  Future<void> _servirPeliculasCard() async {
    AppLogger.logMethod('_servirPeliculasCard', message: 'criticasAmigos: $_criticasAmigos');
    _peliculasCardAmigos.clear();
    try {
      for (var critica in _criticasAmigos) {
        AppLogger.logVar('critica', critica);
        var usuario = await apiService.getUsuarioByID(critica.usuarioUID);
        AppLogger.logVar('usuario', usuario);
        var pelicula = await apiService.getMovieByID(critica.peliculaID.toString());
        AppLogger.logVar('pelicula', pelicula);

        _peliculasCardAmigos.add(PeliculaCard(
          pelicula: pelicula,
          critica: critica,
          usuario: usuario,
        ));
      }
      AppLogger.logVar('peliculasCardAmigos', _peliculasCardAmigos);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Error al servir películas de amigos desde Provider: $e";
      AppLogger.logError(_errorMessage!);
    }
    notifyListeners();
  }

  Future<void> crearCritica(ModeloCritica nuevaCritica) async {
  AppLogger.logMethod('crearCritica', message: 'nuevaCritica: $nuevaCritica');
    try {
      final criticaCreada = await apiService.addCritica(nuevaCritica);
  AppLogger.logVar('criticaCreada', criticaCreada);
      _criticasUsuario.add(criticaCreada);
  AppLogger.logVar('criticasUsuario', _criticasUsuario);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Error al crear crítica desde Provider: $e";
  AppLogger.logError(_errorMessage!);
      notifyListeners();
    }
  }
}