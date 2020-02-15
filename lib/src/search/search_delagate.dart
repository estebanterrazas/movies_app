

import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate  {

  String seleccion = '';

  final peliculas =[

    'Atom',
    'IronMan',
    'Venom',
    'Batman',
    'Locos por las nueces'



  ];

  final peliculasRecientes = [

    'Spider Man',
    'Capitan America'

  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },

      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
        icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation ,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return Center(
      child: Container(
        height: 100.00,
        width: 100.00,
        color: Colors.deepPurpleAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    final listaSugerida = (query.isEmpty)
                          ? peliculasRecientes
                          : peliculas.where((p)=> p.toLowerCase().startsWith(query.toLowerCase())).toList();
    
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder:  (context,i){
        return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: (){
              seleccion = listaSugerida[i];
              showResults(context);
            },
        );
      },
    );
  }

  


}