import 'dart:io';
import 'package:chedo/data/course_record.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CourseDetails extends StatefulWidget {
  final CourseRecord record;

  const CourseDetails(this.record, {Key? key}) : super(key: key);

  @override
  _CourseDetails createState() => _CourseDetails();
}

class _CourseDetails extends State<CourseDetails> {
  bool processing = false, status = false;
  DateTime addDate = DateTime.now();
  String thumbnail =
      "https://ps.w.org/gazchaps-woocommerce-auto-category-product-thumbnails/assets/icon-256x256.png?rev=1848416";
  late File _imageFile;
  String photourl =
      'https://ps.w.org/gazchaps-woocommerce-auto-category-product-thumbnails/assets/icon-256x256.png?rev=1848416';
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ViewImage(photourl)));
              },
              child: SizedBox(
                height: 280,
                width: double.infinity,
                child: PNetworkImage(
                    image: widget.record.imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                    width: 100),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.record.name,
                                    style: const TextStyle(
                                      fontSize: 21,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5)))),
                                    child: Column(
                                      children: <Widget>[
                                        const Text(
                                          "Since",
                                        ),
                                        Chip(
                                          elevation: 12,
                                          label: Text(
                                            widget.record.addDate
                                                    .toDate()
                                                    .day
                                                    .toString() +
                                                ' / ' +
                                                widget.record.addDate
                                                    .toDate()
                                                    .month
                                                    .toString() +
                                                ' / ' +
                                                widget.record.addDate
                                                    .toDate()
                                                    .year
                                                    .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      const Text(
                                        "Duration",
                                      ),
                                      Chip(
                                        elevation: 12,
                                        label: Text(
                                          widget.record.duration + ' hours',
                                        ),
                                        backgroundColor: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                width: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5)))),
                                    child: Column(
                                      children: <Widget>[
                                        const Text(
                                          "Fees",
                                        ),
                                        Chip(
                                          elevation: 12,
                                          label: Text(
                                            widget.record.fees + ' /-',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.record.imageUrl),
                                fit: BoxFit.cover)),
                        margin: const EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          title: Text(
                            "Course Information",
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text(
                            "Added by",
                          ),
                          subtitle: Text(
                            widget.record.addedBy,
                          ),
                          leading: const Icon(Icons.account_box),
                        ),
                        ListTile(
                          title: const Text(
                            "Teacher",
                          ),
                          subtitle: Text(
                            widget.record.teacher,
                          ),
                          leading: const Icon(Icons.person),
                        ),
                        ListTile(
                          title: const Text(
                            "Syllabus",
                          ),
                          subtitle: Text(
                            widget.record.syllabus,
                          ),
                          leading: const Icon(Icons.book),
                        ),
                        ListTile(
                          title: const Text(
                            "note",
                          ),
                          subtitle: Text(
                            widget.record.note,
                          ),
                          leading: const Icon(Icons.note),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ],
        ),
      ),
    );
  }
}

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    required Key key,
    required this.child,
    required this.labelText,
    required this.valueText,
    required this.valueStyle,
    required this.onPressed,
  }) : super(key: key);
  final String labelText;
  final String valueText;

  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  // ignore: use_key_in_widget_constructors
  const PNetworkImage(
      {required this.image,
      required this.fit,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      filterQuality: FilterQuality.high,
      colorBlendMode: BlendMode.colorDodge,
      imageUrl: image,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
