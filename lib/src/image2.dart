import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:regexpattern/src/regex_extension.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Image2 extends StatelessWidget {
  const Image2({
    Key? key,
    required this.source,
    this.fit,
  }) : super(key: key);
  final dynamic source;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    if (source is Uint8List) {
      return Image.memory(
        source,
        fit: fit,
      );
    } else {
      if (source.toString().isUrl()) {
        return FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(source),
          fit: fit,
        );
      } else if (source is File) {
        if (source.path.endsWith(".svg")) {
          return SvgPicture.file(
            source,
            fit: fit ?? BoxFit.contain,
          );
        } else if (source.path.endsWith(".jpg") ||
            source.path.endsWith(".png")) {
          return Image.file(
            source,
            fit: fit,
          );
        } else if (source.path.endsWith(".mp4") ||
            source.path.endsWith(".webm")) {
          return VideoImage(
            source: source,
            fit: fit,
          );
        }
        if (source.path.endsWith(".mp3") ||
            source.path.endsWith(".ogg") ||
            source.path.endsWith(".m4a")) {
          return const Icon(
            Icons.audiotrack,
            color: Colors.purple,
          );
        } else {
          return Container();
        }
      } else if (source is Uri) {
        return Image.file(
          File.fromUri(source),
          fit: fit,
        );
      } else {
        if (source.endsWith(".svg")) {
          return SvgPicture.asset(
            source,
            fit: fit ?? BoxFit.contain,
          );
        } else {
          return Image.asset(
            source,
            fit: fit,
          );
        }
      }
    }
  }
}

class VideoImage extends StatefulWidget {
  const VideoImage({
    Key? key,
    required this.source,
    this.fit,
    this.timeMs = 0,
  }) : super(key: key);
  final dynamic source;
  final BoxFit? fit;
  final int timeMs;
  @override
  _VideoImageState createState() => _VideoImageState();
}

class _VideoImageState extends State<VideoImage> {
  Uint8List? image;
  @override
  void initState() {
    super.initState();
    VideoThumbnail.thumbnailData(
      video: (widget.source is File) ? widget.source.path : widget.source,
      timeMs: widget.timeMs,
    ).then((value) {
      setState(() {
        image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return (image == null)
          ? Image.memory(
              kTransparentImage,
              fit: widget.fit,
            )
          : Image.memory(
              image!,
              fit: widget.fit,
            );
    });
  }
}
