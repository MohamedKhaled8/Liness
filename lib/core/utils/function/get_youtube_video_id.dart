String? getYouTubeVideoId(String url) {
  if (url.isEmpty) {
    return null;
  }

  // Remove any leading/trailing whitespace
  url = url.trim();

  // Handle youtu.be URLs (shortened URLs)
  // Example: https://youtu.be/YmI0bmOK5yo?si=vrW8Mgtka4mrepgh
  if (url.contains('youtu.be/')) {
    // First try regex (more reliable)
    final youtuBeMatch =
        RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})').firstMatch(url);
    if (youtuBeMatch != null && youtuBeMatch.groupCount >= 1) {
      final extracted = youtuBeMatch.group(1);
      if (extracted != null && extracted.length == 11) {
        return extracted;
      }
    }

    // Fallback: try to parse as URI and get first path segment
    final uri = Uri.tryParse(url);
    if (uri != null &&
        uri.host.contains('youtu.be') &&
        uri.pathSegments.isNotEmpty) {
      final videoId = uri.pathSegments.first;
      if (videoId.length >= 11) {
        return videoId.substring(0, 11);
      }
      return videoId;
    }
  }

  // Try to parse as URI
  final Uri? uri = Uri.tryParse(url);
  if (uri == null) {
    // Fallback: try to extract video ID using regex
    final regexMatch = RegExp(
      r'(?:youtube\.com\/watch\?v=|youtube\.com\/embed\/|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    ).firstMatch(url);
    if (regexMatch != null && regexMatch.groupCount >= 1) {
      return regexMatch.group(1);
    }
    return null;
  }

  // Handling different YouTube URL patterns
  if (uri.host.contains('youtube.com')) {
    if (uri.path == '/watch' || uri.path == '/watch/') {
      // Extract video ID from 'v' parameter (ignoring other params like &list=, ?si=)
      final videoId = uri.queryParameters['v'];
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }
    } else if (uri.pathSegments.contains('embed') ||
        uri.pathSegments.contains('v')) {
      // Extract video ID from the path (e.g., /embed/VIDEO_ID or /v/VIDEO_ID)
      final videoIndex = uri.pathSegments.length > 0
          ? (uri.pathSegments.contains('embed') ||
                  uri.pathSegments.contains('v')
              ? uri.pathSegments.length - 1
              : 0)
          : 0;
      if (videoIndex < uri.pathSegments.length) {
        return uri.pathSegments[videoIndex];
      }
    }
  } else if (uri.host == 'youtu.be' || uri.host.contains('youtu.be')) {
    // Extract from shortened URL (ignore query params like ?si=)
    if (uri.pathSegments.isNotEmpty) {
      // Get first segment and remove any query parameters
      final videoId = uri.pathSegments.first;
      // Video ID should be exactly 11 characters
      if (videoId.length == 11 || videoId.length >= 11) {
        return videoId.substring(0, 11);
      }
      return videoId;
    }
  }

  // Final fallback: regex extraction
  final regexMatch = RegExp(
    r'(?:youtube\.com\/watch\?v=|youtube\.com\/embed\/|youtu\.be\/)([a-zA-Z0-9_-]{11})',
  ).firstMatch(url);
  if (regexMatch != null && regexMatch.groupCount >= 1) {
    return regexMatch.group(1);
  }

  return null; // No valid video ID found
}
