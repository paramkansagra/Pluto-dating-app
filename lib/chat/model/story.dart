import '../model/user.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final String url;
  final MediaType media;
  final Duration duration;
  final User user;

  const Story({
    required this.media,
    required this.duration,
    required this.url,
    required this.user,
  });
}
