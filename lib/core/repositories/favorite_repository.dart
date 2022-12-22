import '../models/post_model.dart';
import '../services/localstorage_service.dart';

class FavoriteRepository{

  final String _storageKey = 'favorited_posts';
  final LocalStorageService _storageService = LocalStorageService();

  Future<void> saveToFavoritedPosts(List<Post> posts) async {
    try{
      await _storageService.saveToStorage<List<Post>>(_storageKey, posts);
    }catch(e){
      print(e);
    }
  }

  Future<List<Post>> getFavoritedPosts() async {
    try{
      final _favoritedPosts = await _storageService.getFromStorage(_storageKey);
      return (_favoritedPosts != null) ? List<Post>.from((_favoritedPosts as List).map((post) => Post.fromLocalJson(post))).toList() : [];
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<bool> clearFavoritedPosts() async {
    try{
      await _storageService.remove(_storageKey);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

}