import 'package:flutter/material.dart';
import 'package:flutter_peliculas/models/models.dart';
import 'package:flutter_peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => "Buscar...";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("buildResults");
  }

  Widget _emtypData() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emtypData();
    }
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.suggestionByQuery(query);

    return StreamBuilder(
        stream: moviesProvider.suggestonStream,
        builder: (_, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return _emtypData();
          final listmovies = snapshot.data;
          return ListView.builder(
            itemCount: listmovies.length,
            itemBuilder: (_, index) => _MovieItem(listmovies[index],
                '$index-${listmovies[index].id}-${listmovies[index].title}'),
          );
        });
  }
}

class _MovieItem extends StatelessWidget {
  final Movies muvie;
  final String heroId;
  const _MovieItem(this.muvie, this.heroId);
  @override
  Widget build(BuildContext context) {
    muvie.heroId = heroId;
    return ListTile(
      leading: Hero(
        tag: heroId,
        child: FadeInImage(
          image: NetworkImage(muvie.fullPostImg),
          placeholder: AssetImage("assets/no-image.jpg"),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(muvie.title),
      subtitle: Text(muvie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'ditails', arguments: muvie);
      },
    );
  }
}
