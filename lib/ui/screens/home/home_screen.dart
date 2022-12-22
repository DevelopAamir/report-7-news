import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:report7news/core/app.dart';
import 'package:report7news/core/repositories/auth_repo.dart';
import 'package:report7news/core/services/localstorage_service.dart';
import 'package:report7news/firbaseService.dart';
import 'package:tuple/tuple.dart';
import '../../../core/enums/ui_enums.dart';
import '../../widgets/common/index.dart' show SectionContainer;
import '../../widgets/posts/index.dart' show PostsList, PostsSlider;
import '../../../core/common/app_theme.dart';
import '../../../core/enums/core_enums.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/models/app_model.dart';
import '../../../core/models/category_model.dart';
import '../../../core/models/post_model.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/post_repository.dart';
import '../../../core/router.dart';
import '../../../core/services/routing_service.dart';
import '../../../core/utils/api_response.dart';
import '../../widgets/categories/lists/categories_horizantal_list.dart';
import '../../widgets/common/data_loading.dart';
import '../../widgets/common/error_message.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostRepository _postRepository = PostRepository();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String loggedinUser = '';
  String name = '';
  String address = '';
  String phoneNumber;
  String url;
  void userData() async {
    try {
      _firestore
          .collection(loggedinUser)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (mounted)
            setState(() {
              name = doc["Name"];
              address = doc["address"];
              phoneNumber = doc["phoneNumber"];
              url = doc['url'];
              print("aa");
            });
          print(doc["address"]);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        setState(() {
          loggedinUser = user.email.toString();
        });

        print(loggedinUser);
      }
      userData();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void _onViewPostsList(BuildContext context, String title, [String query]) {
    Navigator.pushNamed(
      context,
      AppRoutes.postsList,
      arguments: Tuple2<String, String>(title, query),
    );
  }

  Widget _renderHomeLayout(BuildContext context, HomeLayout layout) {
    switch (layout.layoutType) {
      case 'spotlights':
        return _renderSpotlightPostsLayout(context, layout.data);
        break;
      case 'categories':
        return _renderCateogriesLayout(layout.data);
        break;
      case 'posts':
        return _renderCategoryPostsLayout(context, layout.data);
        break;
      case 'latestposts':
        return _renderLatestPosts(context, layout.data);
        break;
    }
    return Container();
  }

  Widget _renderCateogriesLayout(List<Category> categories) {
    if (categories == null || categories.isEmpty) return SizedBox();
    return CategoriesHorizantalList(
      categories: categories,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      margin: const EdgeInsets.only(top: 15),
    );
  }

  Widget _renderSpotlightPostsLayout(BuildContext context, List<int> postsIds) {
    if (postsIds == null || postsIds.isEmpty) return SizedBox();
    return SectionContainer(
      title: transulate(context, 'spotlight_posts'),
      moreNavigation: () => _onViewPostsList(
          context,
          transulate(context, 'spotlight_posts'),
          '&lucodeia_get=lucodeia_spotlight'),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      margin: const EdgeInsets.only(top: 15),
      heightAboveChild: 5,
      child: FutureBuilder(
        future:
            _postRepository.getPosts(query: '?include=${postsIds.join(',')}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DataLoading(
              padding: const EdgeInsets.symmetric(vertical: 25),
            );
          } else {
            if (snapshot.error != null) {
              return ErrorMessage();
            } else {
              ApiResponse<List<Post>> _response =
                  snapshot.data as ApiResponse<List<Post>>;

              if (_response.error) {
                return ErrorMessage(
                  message: _response.message,
                );
              } else {
                return PostsSlider(
                  posts: _response.data,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _renderCategoryPostsLayout(
      BuildContext context, LayoutPostsCategory layoutCategory) {
    if (layoutCategory == null || layoutCategory.id == null) return SizedBox();
    return SectionContainer(
      title: layoutCategory.title,
      moreNavigation: () => _onViewPostsList(
          context, layoutCategory.title, '&categories=${layoutCategory.id}'),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      margin: const EdgeInsets.only(top: 15),
      heightAboveChild: 5,
      child: FutureBuilder(
        future:
            _postRepository.getPosts(query: '?categories=${layoutCategory.id}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DataLoading(
              padding: const EdgeInsets.symmetric(vertical: 25),
            );
          } else {
            if (snapshot.error != null) {
              return ErrorMessage();
            } else {
              ApiResponse<List<Post>> _response =
                  snapshot.data as ApiResponse<List<Post>>;

              if (_response.error) {
                return ErrorMessage(
                  message: _response.message,
                );
              } else {
                return PostsSlider(
                  posts: _response.data,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }

  Widget _renderLatestPosts(BuildContext context, String totalPosts) {
    return SectionContainer(
      title: transulate(context, 'latest_posts'),
      moreNavigation: () =>
          _onViewPostsList(context, transulate(context, 'latest_posts')),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      margin: const EdgeInsets.only(top: 15),
      heightAboveChild: 5,
      child: FutureBuilder(
        future: _postRepository.getPosts(query: '?per_page=$totalPosts'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DataLoading(
              padding: const EdgeInsets.symmetric(vertical: 25),
            );
          } else {
            if (snapshot.error != null) {
              return ErrorMessage();
            } else {
              ApiResponse<List<Post>> _response =
                  snapshot.data as ApiResponse<List<Post>>;

              if (_response.error) {
                return ErrorMessage(
                  message: _response.message,
                );
              } else {
                return PostsList(
                  posts: _response.data,
                  listType: PostsListType.verticalList,
                );
              }
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Stack(
                children: [
                  Container(color: Colors.indigo),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: ClipOval(
                            child: url != null
                                ? Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    width: 120.0,
                                    height: 120.0,
                                  )
                                : Icon(Icons.person),
                          ),
                          maxRadius: 35,
                          minRadius: 25,
                        ),
                        Container(
                          width: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: $name',
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              Text(
                                'Email: $loggedinUser',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              Text(
                                'Address: $address',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text("Logout"),
              onTap: () {
                FirebaseService().logout();
                AuthRepo().logOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoggedInState()));
              },
            ),
            ListTile(
              leading: Icon(Icons.lock_open),
              title: Text("Change Password"),
              onTap: () {
                FirebaseService().updatePassword(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(transulate(context, 'home_screen')),
        shape: appBarShape,
      ),
      body: Selector<AppProvider, List<HomeLayout>>(
        selector: (_, app) => app.appConfigs.homeScreenLayouts,
        builder: (_, homeLayouts, __) {
          if (homeLayouts != null && homeLayouts.length > 0) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: homeLayouts
                    .map((layout) => _renderHomeLayout(context, layout))
                    .toList(),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
