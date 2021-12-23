import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:photo_manager/photo_manager.dart';

class GridGallery extends StatefulWidget {
  final ScrollController? scrollCtr;
  final RequestType type;
  final ValueChanged<AssetEntity> update;

  const GridGallery(
      {Key? key, this.scrollCtr, required this.type, required this.update})
      : super(key: key);

  @override
  _GridGalleryState createState() => _GridGalleryState();
}

class _GridGalleryState extends State<GridGallery> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true, type: widget.type);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 60); //preloading files
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(200, 200), //resolution of thumbnail
            builder:
                (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          widget.update(asset);
                        },
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 5),
                          child: Icon(
                            Icons.videocam,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              }
              return Container(
                color: Colors.grey,
                width: 200,
                height: 200,
              );
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
          controller: widget.scrollCtr,
          itemCount: _mediaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            return _mediaList[index];
          }),
    );
  }
}
