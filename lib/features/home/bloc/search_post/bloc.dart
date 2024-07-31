import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:insta_clone/features/home/repository/AddPost.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
import 'state.dart';
import 'package:http/http.dart' as http;
import 'package:insta_clone/features/home/environment.dart';

class SearchPostBloc extends Bloc<SearchPostEvent, SearchPostState> {
  final AddPostRepo addPostRepo;

  SearchPostBloc( {required this.addPostRepo}) : super(SearchPostInitState());

  @override
  Stream<SearchPostState> mapEventToState(SearchPostEvent event) async* {
    if (event is SearchQueryChanged) {
      yield SearchPostLoadingState();
      try {
        final URL= environment.Url;
        final response = await http.post(Uri.parse('$URL/post/search?keyword=${event.keyword}'));
        final List<String> results = (response.body as List).map((item) => item.toString()).toList();
        yield SearchPostSuccessState(results);
      } catch (e) {
        yield SearchPostErrorState(message: 'Failed to fetch data');
      }
    }
  }
}
