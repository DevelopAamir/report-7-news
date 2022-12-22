
import '../constants/config.dart' as config show commentsPerPage;

String get appOptions => '/wp-json/lucodeia/v1/options';
String get categories => '/wp-json/wp/v2/categories';
String get login => '/wp-json/jwt-auth/v1/';
String posts(String query) => '/wp-json/wp/v2/posts$query';
String postComments(int postId, [int page = 1, int perPage = config.commentsPerPage]) => '/wp-json/wp/v2/comments?post=$postId&page=$page&per_page=$perPage';
String get addPostComment => '/wp-json/wp/v2/comments';
String page(int pageId) => '/wp-json/wp/v2/pages/$pageId';
String contact(int formId) => '/wp-json/contact-form-7/v1/contact-forms/$formId/feedback';
