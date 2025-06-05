import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/movie.dart';

class MovieComponent extends StatelessWidget {
  const MovieComponent({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).chipTheme.backgroundColor,
      child: Column(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w200${movie.posterPath}',
            fit: BoxFit.fitWidth,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      movie.title,
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  Icon(Icons.favorite_border, color: Colors.black)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
