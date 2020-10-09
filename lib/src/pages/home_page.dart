import 'package:flutter/material.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
 

// class HomePage extends StatefulWidget {

//   @override
//   _HomePageState createState() => _HomePageState();
// }

class HomePage extends StatelessWidget {

  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        
        title: Text('Películas en cines'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context, 
                delegate: DataSearch(),
                //query: Valor asignado al input search
              );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _wiperTarjetas(),
            _footer(context),
          ],
        )
      )
    );
  }

  Widget _wiperTarjetas() {

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
     
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if ( snapshot.hasData ) {
            return CardSwiper(
            peliculas: snapshot.data
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      //width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Polulares', style: Theme.of(context).textTheme.subhead)
          ),

          SizedBox(height: 10.0),

          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if ( snapshot.hasData ) {
                  return MovieHorizontal(
                    peliculas: snapshot.data,
                    siguientePagina: peliculasProvider.getPopulares,
                  );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
            // FutureBuilder(
            // future: peliculasProvider.getPopulares(),
            // builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            //   if ( snapshot.hasData ) {
            //       return MovieHorizontal(peliculas: snapshot.data);
            //   } else {
            //     return Center(child: CircularProgressIndicator());
            //   }
            // }
          )
        ],
      )
    );
  }
}
