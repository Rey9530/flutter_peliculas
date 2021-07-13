import 'package:flutter/material.dart';
import 'package:flutter_peliculas/providers/movies_provider.dart';
import 'package:flutter_peliculas/search/search_delegate.dart';
import 'package:flutter_peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Peliculas en cines"),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_outlined,
              ),
              onPressed: () {
                showSearch(context: context, delegate: MovieSearchDelegate());
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(movies: moviesProvider.listMovies),
              MovieSlider(
                populares: moviesProvider.popularMovies,
                titulo: "Populares!",
                hacerLlamada: () => moviesProvider.getPopularMovie(),
              ),
            ],
          ),
        ));
  }
}
