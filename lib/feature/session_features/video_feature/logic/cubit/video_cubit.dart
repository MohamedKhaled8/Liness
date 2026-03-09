import '../state/video_state.dart';
import 'package:flutter/widgets.dart';
import '../../data/model/video_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/video_session_repo.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VideoCubit extends Cubit<VideoState> {
  VideoCubit({required this.videoSessionRepository}) : super(VideoInitState());

  final VideoSessionRepository videoSessionRepository;
  VideoModel? videoModel;
  int? currentSessionId;

  // Map to store notes: {sessionId: [note1, note2, ...]}
  List<String> currentVideoNotes = [];

  void clearResources() {
    videoModel = null;
    currentVideoNotes = [];
    currentSessionId = null;
    emit(VideoInitState());
  }

  //// GET VIDEO SESSION DATA
  Future<void> getVideoSessionData({
    required int sessionId,
    required BuildContext context,
  }) async {
    this.currentSessionId = sessionId; // TRACK THE SESSION ID
    emit(VideoLoadingState());

    // Load local notes first
    await loadNotes(sessionId);

    final result = await videoSessionRepository.getVideoSessionData(
      sessionId: sessionId,
    );

    result.fold(
      (errMessage) {
        emit(VideoErrorState());
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );
      },
      (videoModel) async {
        this.videoModel = videoModel;

        if (videoModel.videoLink.contains("vimeo.com")) {
          final validateLinke =
              this.videoModel!.videoLink.replaceAll('?share=copy', '');
          this.videoModel!.videoLink = validateLinke.split('/').last;
        }

        emit(VideoLoadedState());
        emit(VideoGetDataSuccessState());
      },
    );
  }

  // --- Persistence Logic for Notes ---

  Future<void> loadNotes(int sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('video_notes_$sessionId');
    if (notesJson != null) {
      currentVideoNotes = List<String>.from(json.decode(notesJson));
    } else {
      currentVideoNotes = [];
    }
    emit(VideoGetDataSuccessState()); // Trigger UI update
  }

  Future<void> addNote(int sessionId, String note) async {
    if (note.trim().isEmpty) return;

    currentVideoNotes.add(note.trim());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'video_notes_$sessionId', json.encode(currentVideoNotes));

    emit(VideoGetDataSuccessState()); // Trigger UI update to show new note
  }

  @override
  Future<void> close() {
    clearResources();
    return super.close();
  }
}
