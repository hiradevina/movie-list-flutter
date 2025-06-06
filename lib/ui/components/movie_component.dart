import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movielist/ui/uimodel/movie_ui_model.dart';

class MovieComponent extends StatelessWidget {
  const MovieComponent({super.key, required this.uimodel, required this.onPress});

  final MovieUiModel uimodel;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).chipTheme.backgroundColor,
      child: Column(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w200${uimodel.movie.posterPath}',
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
                      uimodel.movie.title,
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  IconButton(
                    onPressed: () => { onPress() },
                    icon: Icon(
                        uimodel.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
