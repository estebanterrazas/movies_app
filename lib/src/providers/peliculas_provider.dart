import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:http/http.dart' as http;

class PeliculasProvider{

  String _apikey = 'ecbfa4b4163b1e0883f47f9e812a7761';
  String _url    = 'api.themoviedb.org';
  String _lenguage    = 'es-MX';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();


  Function(List<Pelicula>)  get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams(){
    _popularesStreamController?.close();
  }

   Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

     final resp = await http.get(url);
   final decodedData = json.decode(resp.body);

  final peliculas = new Peliculas.fromJsonList(decodedData['results']);

  return peliculas.items;


   }

 Future<List<Pelicula>> getEnCines() async{

   final url = Uri.https(_url, '3/movie/now_playing', {
     'api_key'  : _apikey,
     'lenguage' : _lenguage,

   });

    
  return await _procesarRespuesta(url);


 }

 Future<List<Pelicula>> getPopulares() async{

    if(_cargando) return [];
    _cargando = true;
    _popularesPage ++;
    
   

     final url = Uri.https(_url, '3/movie/popular', {
     'api_key'  : _apikey,
     'lenguage' : _lenguage,
     'page' :  _popularesPage.toString()



   });


   final resp = await _procesarRespuesta(url);

   _populares.addAll(resp);
   popularesSink(_populares);

   _cargando = false;

   return resp;
   


  }

  
  
  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits',{

      'api_key' : _apikey,
      'lenguage': _lenguage
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;

  }


}