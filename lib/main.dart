import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insta_clone/features/home/bloc/addStorie/story/bloc.dart';
import 'package:insta_clone/features/home/bloc/following/bloc.dart';
import 'package:insta_clone/features/home/bloc/registre/bloc.dart';
import 'package:insta_clone/features/home/bloc/search_post/bloc.dart';
import 'package:insta_clone/features/home/repository/AddPost.dart';
import 'package:insta_clone/features/home/repository/Following_repo.dart';
import 'package:insta_clone/features/home/repository/Registre_repo.dart';
import 'package:insta_clone/features/home/repository/Story_repo.dart';
import 'package:insta_clone/features/home/repository/getUser.dart';
import 'package:provider/provider.dart';

import 'features/home/bloc/add_post/bloc.dart';
import 'features/home/bloc/edit_profile/bloc.dart';
import 'features/home/bloc/getUser/get_user/bloc.dart';
import 'features/home/bloc/unfollow/bloc.dart';
import 'features/home/repository/EditProfile_repo.dart';
import 'features/home/repository/Login_repo.dart';
import 'features/home/bloc/login/login/bloc.dart';
import 'features/home/repository/UnFollowin_repo.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/login/login.dart';
import 'generated/l10n.dart';
import 'utils/theme/theme_state.dart';
import 'utils/theme/themes.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "BDw8IadhW_c_5r6JuYTYP00Mv2LdHKDYFk8UhUag0wWLZ72zyINawC9tcAGwaZrzz1G1ZB243ubc8IcH6Fq2LFA",
      authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
      projectId: "instazeal-5193c",
      storageBucket: "YOUR_PROJECT_ID.appspot.com",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "YOUR_APP_ID",
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),  // Fournir ThemeProvider
        BlocProvider(
          create: (_) => LoginBloc(loginRepo: LoginRepo()),
        ),
        BlocProvider(
          create: (_) => RegistreBloc(registreRepo: RegistreRepo()),
        ),
        BlocProvider(
          create: (_) => StoryBloc(storyRepo: StoryRepo()),
        ),
        BlocProvider(
          create: (_) => getUserBloc( getuserrepo: getUserRepo()),
        ),
        BlocProvider(
          create: (_) => EditProfileBloc( editProfileRepo: EditProfileRepo()),
        ),
        BlocProvider(
          create: (_) => AddPostBloc( addPostRepo: AddPostRepo()),
        ),
        BlocProvider(
          create: (_) => FollowingBloc( followingRepo: FollowingRepo()),
        ),
        BlocProvider(
          create: (_) => UnFollowingBloc( unFollowingRepo: UnFollowingRepo()),
        ),
        BlocProvider(
          create: (_) => SearchPostBloc( addPostRepo: AddPostRepo()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('en', 'US'),
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode ? ThemeMode.dark : ThemeMode.light,
          home: loginwidget(),  // Assure-toi que `loginwidget()` utilise le contexte correctement
        );
      },
    );
  }
}
