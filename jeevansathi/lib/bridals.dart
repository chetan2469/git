import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'constants/constants.dart';
import 'dataTypes/record.dart';

class Bride extends StatefulWidget {
  final List<Record> filteredcandidateList;
  final Function fetchcandidateList;
  Bride(this.filteredcandidateList, this.fetchcandidateList);

  @override
  _BrideState createState() =>
      _BrideState(filteredcandidateList, this.fetchcandidateList);
}

class _BrideState extends State<Bride> {
  final List<Record> filteredcandidateList;
  final Function fetchcandidateList;
  _BrideState(this.filteredcandidateList, this.fetchcandidateList);
  FirebaseUser user;
  String photourl = null;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
      

  void _onRefresh() async {
    print('refreshing...');
    // monitor network fetch
    fetchcandidateList();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print('loading...');
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
            this.photourl = user.photoUrl;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: Card(
        elevation: 5,
        shape: StadiumBorder(),
        child: Container(
          width: 160,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            width: 0, color: Colors.grey.withOpacity(.2)))),
                child: Row(
                  children: <Widget>[
                    Text('Filter '),
                    Transform.rotate(
                        angle: 3.14 * 990,
                        child: Icon(
                          FontAwesomeIcons.slidersH,
                          size: 15,
                        ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            width: 0, color: Colors.grey.withOpacity(.2)))),
                child: Row(
                  children: <Widget>[
                    Text('Sort'),
                    Icon(
                      FontAwesomeIcons.filter,
                      size: 15,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Icon(FontAwesomeIcons.alignLeft),
                            ),
                            InkWell(
                              onTap: () {
                                print(filteredcandidateList.length);
                                print(filteredcandidateList.length);
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.centerLeft,
                                child: Image.asset('assets/sakRed.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.centerRight,
                              child: Icon(FontAwesomeIcons.search),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10),
                              alignment: Alignment.centerRight,
                              // child: CircleAvatar(
                              //   backgroundImage: NetworkImage(user.photoUrl),
                              // ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: Container(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      itemCount: filteredcandidateList.length,
                      itemBuilder: (builder, index) {
                        return filteredcandidateList[index].active &&
                                filteredcandidateList[index].gender == 'Female'
                            ? Container(
                                height: 160,
                                width: 160,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            color: Colors.white,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 20,
                                                          left: 10,
                                                          right: 10),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              filteredcandidateList[
                                                                              index]
                                                                          .thumbnail !=
                                                                      null
                                                                  ? filteredcandidateList[
                                                                          index]
                                                                      .thumbnail
                                                                  : filteredcandidateList[
                                                                          index]
                                                                      .photoUrl,
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .name,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .redAccent,
                                                              )),
                                                          TextSpan(
                                                              text: '\t\t\t' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .sakId,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: '\n' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .proffesion +
                                                                  '\t\t' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .education,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: '\n' +
                                                                  (Timestamp.now()
                                                                              .toDate()
                                                                              .year -
                                                                          filteredcandidateList[index]
                                                                              .dob
                                                                              .toDate()
                                                                              .year)
                                                                      .toString() +
                                                                  ' years , ' +
                                                                  ' ' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .height +
                                                                  ' ft height',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: '\n' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .birthPlace +
                                                                  ' ,' +
                                                                  filteredcandidateList[
                                                                          index]
                                                                      .birthState,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 16),
                                                        alignment:
                                                            Alignment.topCenter,
                                                        child: Icon(
                                                          FontAwesomeIcons
                                                              .ellipsisH,
                                                          color: Colors.grey,
                                                        )))
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 2,
                                      ),

                                      //  !!!!!!!!!!!!!!!!     Row
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: Colors.white,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .redAccent,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50)),
                                                            child: Icon(
                                                              FontAwesomeIcons
                                                                  .comment,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .redAccent,
                                                            width: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color:
                                                            Colors.redAccent),
                                                    child: Center(
                                                        child: Text(
                                                      "View Profile",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
