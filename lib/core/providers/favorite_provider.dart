import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../repositories/favorite_repository.dart';

class FavoriteProvider with ChangeNotifier {

  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  Map<int, Post> _favoritedPostsMap = {};
  List<Post> get favoritedPosts => _favoritedPostsMap.values.toList();

  FavoriteProvider(){
    getFavoritedPostsFromLocal();
  }

  void getFavoritedPostsFromLocal() async {
    List<Post> _favoritedPosts = await _favoriteRepository.getFavoritedPosts();
    _favoritedPosts.forEach((Post post) {
      _favoritedPostsMap[post.id] = post;
    });
  }

  void favoritePost(Post post){
    if(post != null){
      if(_getPostFromMapById(post.id) == null){
        _favoritedPostsMap[post.id] = post;
      }else{
        _favoritedPostsMap.remove(post.id);
      }
      _favoriteRepository.saveToFavoritedPosts(favoritedPosts);
    }
    notifyListeners();
  }

  Post _getPostFromMapById(int id){
    if(id != null && id != 0){
      final Post _postFromMap = _favoritedPostsMap[id];
      if(_postFromMap != null && _postFromMap.id == id) return _postFromMap;
    }
    return null;
  }

  bool isFavoritedPost(int postId){
    return _getPostFromMapById(postId) != null ? true : false;
  }

  Future<void> clearFavoritedPosts() async {
    _favoritedPostsMap.clear();
    await _favoriteRepository.clearFavoritedPosts();
    notifyListeners();
  }

}