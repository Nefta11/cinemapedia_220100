import 'package:dio/dio.dart';

import 'package:cinemapedia_220100/config/constants/environment.dart';
import 'package:cinemapedia_220100/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia_220100/infraestructure/mappers/movie_mapper.dart';
import 'package:cinemapedia_220100/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia_220100/domain/entities/movie.dart';


class MoviedbDatasource extends MoviesDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    }
  ));


  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    
    final response = await dio.get('/movie/now_playing');
    final movieDBResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDBResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster' )
    .map(
      (moviedb) => MovieMapper.movieDBToEntity(moviedb)
    ).toList();

    return movies;
  }



}