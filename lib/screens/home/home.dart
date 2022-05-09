import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/%20services/auth.dart';
import 'package:untitled/%20services/database.dart';
import 'package:untitled/main.dart';
import 'package:untitled/models/bentis.dart';
import 'package:untitled/screens/home/Profile.dart';
import 'package:untitled/screens/home/bentis_list.dart';
import 'package:untitled/screens/post/creation.dart';
import 'package:untitled/models/cities.dart';
import '../../models/listing.dart';
import '../authenticate/sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
String phoneNumber = '';
String name = '';
String surname = '';

class Home extends StatefulWidget {
  final List<String>? cities;

  const Home(this.cities, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Bentis1>>.value(
        value: DatabaseService(uid: '').Bentis,
        initialData: [],
        child: Scaffold(
          body: DashboardScreen(title: 'posts',),
          backgroundColor: Colors.brown[50],
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: () =>
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePost(widget.cities)),
              ),
            },
          ),
          appBar: AppBar(
              title: const Text('Bentis'),
              backgroundColor: Colors.black,
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person),
                  label: Text('Profile'),
                  onPressed: () =>
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(widget.cities)),
                    ),
                  },
                )
              ]
          ),
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
    return Scaffold(body: RefreshIndicator(
      onRefresh: () async =>
      await Future.delayed(const Duration(seconds: 2)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: listingList,
          builder: (BuildContext context,
              AsyncSnapshot<List<Listing>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.separated(
                  itemCount: retrievedListingList!.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: ((direction) async {
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
                            color:
                            const Color.fromARGB(255, 83, 80, 80),
                            borderRadius: BorderRadius.circular(16.0)),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, "/edit",
                                arguments:
                                retrievedListingList![index]);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title:
                          Text(retrievedListingList![index].user),
                          subtitle: Text(
                              "${retrievedListingList![index]
                                  .departure}, ${retrievedListingList![index]
                                  .destination}"),
                          trailing: const Icon(Icons.arrow_right_sharp),
                        ),
                      ),
                    );
                  });
            } else if (snapshot.connectionState ==
                ConnectionState.done){
              return Center(
                child: ListView(
                  children: const <Widget>[
                    Align(
                        alignment: AlignmentDirectional.center,
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



