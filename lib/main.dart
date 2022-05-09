import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/models/cities.dart';
import 'package:untitled/models/user.dart';
import 'package:untitled/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

import ' services/database.dart';
import 'models/listing.dart';
import 'notifier/Listing_notifier.dart';
Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<String>? cities=await Cities.GetCitiesAsync();
  runApp(new MyApp(cities));
}
class MyApp extends StatelessWidget {
  final List<String>? cities;
  const MyApp(this.cities, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
        value:AuthService().user,
        catchError: (_,__) {
          return null;
        },
        initialData: null,
        child: MaterialApp(
        home: Wrapper(cities),
    )
    );
  }
}
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {
  DatabaseService service = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  Future<List<Listing>>? listingList;
  List<Listing>? retrievedListingList;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    listingList = service.retrieveListing();
    retrievedListingList = await service.retrieveListing();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 2)),

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: listingList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Listing>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedListingList!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: ((direction) async{
                          await service.deleteListing(
                              retrievedListingList![index].id.toString());
                        }),
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: const EdgeInsets.only(right: 28.0),
                          alignment: AlignmentDirectional.centerEnd,
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        resizeDuration: const Duration(milliseconds: 200),
                        key: UniqueKey(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 83, 80, 80),
                              borderRadius: BorderRadius.circular(16.0)),
                          child: ListTile(
                            onTap:() {
                              Navigator.pushNamed(context, "/edit", arguments: retrievedListingList![index]);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text(retrievedListingList![index].user),
                            subtitle: Text(
                                "${retrievedListingList![index].departure}, ${retrievedListingList![index].destination}"),
                            trailing: const Icon(Icons.arrow_right_sharp),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  retrievedListingList!.isEmpty) {
                return Center(
                  child: ListView(
                    children: const <Widget>[
                      Align(alignment: AlignmentDirectional.center,
                          child: Text('No data available')),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            Navigator.pushNamed(context, '/add');
          }),
          tooltip: 'add',
          child: const Icon(Icons.add),
        )
    );
  }
}




