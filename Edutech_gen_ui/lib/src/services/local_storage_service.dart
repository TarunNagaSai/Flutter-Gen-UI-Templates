import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/index.dart';

/// Service for managing local storage using SharedPreferences
/// 
/// Handles persistence of:
/// - Chat history entries
/// - Summaries and saved notes
/// - Quiz data and results
class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._();

  factory LocalStorageService() => _instance;

  LocalStorageService._();

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Storage keys
  static const String _chatHistoryKey = 'chat_history';
  static const String _summariesKey = 'summaries';
  static const String _savedNotesKey = 'saved_notes';
  static const String _quizResultsKey = 'quiz_results';
  static const String _quizzesKey = 'quizzes';

  /// Initialize the service
  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Ensure initialization before any operation
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('LocalStorageService must be initialized with init()');
    }
  }

  // ==================== Chat History ====================

  /// Save a chat entry
  Future<void> saveChatEntry(ChatEntry entry) async {
    _ensureInitialized();
    try {
      final history = await getChatHistory();
      history.add(entry);
      final jsonList = history.map((e) => e.toJson()).toList();
      await _prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to save chat entry: $e');
    }
  }

  /// Get all chat history entries
  Future<List<ChatEntry>> getChatHistory() async {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(_chatHistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ChatEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load chat history: $e');
    }
  }

  /// Get a specific chat entry by ID
  Future<ChatEntry?> getChatEntry(String id) async {
    _ensureInitialized();
    try {
      final history = await getChatHistory();
      return history.firstWhere(
        (entry) => entry.id == id,
        orElse: () => ChatEntry(
          id: '',
          userQuery: '',
          aiExplanation: '',
          topic: '',
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Update a chat entry
  Future<void> updateChatEntry(ChatEntry entry) async {
    _ensureInitialized();
    try {
      final history = await getChatHistory();
      final index = history.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        history[index] = entry;
        final jsonList = history.map((e) => e.toJson()).toList();
        await _prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
      }
    } catch (e) {
      throw Exception('Failed to update chat entry: $e');
    }
  }

  /// Delete a chat entry
  Future<void> deleteChatEntry(String id) async {
    _ensureInitialized();
    try {
      final history = await getChatHistory();
      history.removeWhere((e) => e.id == id);
      final jsonList = history.map((e) => e.toJson()).toList();
      await _prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to delete chat entry: $e');
    }
  }

  /// Clear all chat history
  Future<void> clearChatHistory() async {
    _ensureInitialized();
    try {
      await _prefs.remove(_chatHistoryKey);
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }

  // ==================== Summaries ====================

  /// Save a summary
  Future<void> saveSummary(Summary summary) async {
    _ensureInitialized();
    try {
      final summaries = await getSummaries();
      summaries.add(summary);
      final jsonList = summaries.map((s) => s.toJson()).toList();
      await _prefs.setString(_summariesKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to save summary: $e');
    }
  }

  /// Get all summaries
  Future<List<Summary>> getSummaries() async {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(_summariesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => Summary.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load summaries: $e');
    }
  }

  /// Get a specific summary by ID
  Future<Summary?> getSummary(String id) async {
    _ensureInitialized();
    try {
      final summaries = await getSummaries();
      return summaries.firstWhere(
        (summary) => summary.id == id,
        orElse: () => null as Summary,
      );
    } catch (e) {
      return null;
    }
  }

  /// Mark a summary as saved (note)
  Future<void> markSummaryAsSaved(String summaryId) async {
    _ensureInitialized();
    try {
      final summary = await getSummary(summaryId);
      if (summary != null) {
        final updated = summary.copyWith(isSaved: true);
        await updateSummary(updated);
      }
    } catch (e) {
      throw Exception('Failed to mark summary as saved: $e');
    }
  }

  /// Update a summary
  Future<void> updateSummary(Summary summary) async {
    _ensureInitialized();
    try {
      final summaries = await getSummaries();
      final index = summaries.indexWhere((s) => s.id == summary.id);
      if (index != -1) {
        summaries[index] = summary;
        final jsonList = summaries.map((s) => s.toJson()).toList();
        await _prefs.setString(_summariesKey, jsonEncode(jsonList));
      }
    } catch (e) {
      throw Exception('Failed to update summary: $e');
    }
  }

  /// Delete a summary
  Future<void> deleteSummary(String id) async {
    _ensureInitialized();
    try {
      final summaries = await getSummaries();
      summaries.removeWhere((s) => s.id == id);
      final jsonList = summaries.map((s) => s.toJson()).toList();
      await _prefs.setString(_summariesKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to delete summary: $e');
    }
  }

  /// Get all saved notes (summaries marked as saved)
  Future<List<Summary>> getSavedNotes() async {
    _ensureInitialized();
    try {
      final summaries = await getSummaries();
      return summaries.where((s) => s.isSaved).toList();
    } catch (e) {
      throw Exception('Failed to load saved notes: $e');
    }
  }

  /// Clear all summaries
  Future<void> clearSummaries() async {
    _ensureInitialized();
    try {
      await _prefs.remove(_summariesKey);
    } catch (e) {
      throw Exception('Failed to clear summaries: $e');
    }
  }

  // ==================== Quiz Results ====================

  /// Save a quiz result
  Future<void> saveQuizResult(QuizResult result) async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      results.add(result);
      final jsonList = results.map((r) => r.toJson()).toList();
      await _prefs.setString(_quizResultsKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  /// Get all quiz results
  Future<List<QuizResult>> getQuizResults() async {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(_quizResultsKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => QuizResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load quiz results: $e');
    }
  }

  /// Get a specific quiz result by ID
  Future<QuizResult?> getQuizResult(String id) async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      return results.firstWhere(
        (result) => result.id == id,
        orElse: () => null as QuizResult,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get the latest quiz result
  Future<QuizResult?> getLatestQuizResult() async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      if (results.isEmpty) return null;
      return results.reduce((a, b) =>
          a.completedAt.isAfter(b.completedAt) ? a : b);
    } catch (e) {
      return null;
    }
  }

  /// Get quiz results for a specific topic
  Future<List<QuizResult>> getQuizResultsByTopic(String topic) async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      return results.where((r) => r.topic == topic).toList();
    } catch (e) {
      throw Exception('Failed to load quiz results for topic: $e');
    }
  }

  /// Update a quiz result (e.g., mark as saved)
  Future<void> updateQuizResult(QuizResult result) async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      final index = results.indexWhere((r) => r.id == result.id);
      if (index != -1) {
        results[index] = result;
        final jsonList = results.map((r) => r.toJson()).toList();
        await _prefs.setString(_quizResultsKey, jsonEncode(jsonList));
      }
    } catch (e) {
      throw Exception('Failed to update quiz result: $e');
    }
  }

  /// Delete a quiz result
  Future<void> deleteQuizResult(String id) async {
    _ensureInitialized();
    try {
      final results = await getQuizResults();
      results.removeWhere((r) => r.id == id);
      final jsonList = results.map((r) => r.toJson()).toList();
      await _prefs.setString(_quizResultsKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to delete quiz result: $e');
    }
  }

  /// Clear all quiz results
  Future<void> clearQuizResults() async {
    _ensureInitialized();
    try {
      await _prefs.remove(_quizResultsKey);
    } catch (e) {
      throw Exception('Failed to clear quiz results: $e');
    }
  }

  // ==================== Quizzes ====================

  /// Save a quiz
  Future<void> saveQuiz(Quiz quiz) async {
    _ensureInitialized();
    try {
      final quizzes = await getQuizzes();
      quizzes.add(quiz);
      final jsonList = quizzes.map((q) => q.toJson()).toList();
      await _prefs.setString(_quizzesKey, jsonEncode(jsonList));
    } catch (e) {
      throw Exception('Failed to save quiz: $e');
    }
  }

  /// Get all quizzes
  Future<List<Quiz>> getQuizzes() async {
    _ensureInitialized();
    try {
      final jsonString = _prefs.getString(_quizzesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => Quiz.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load quizzes: $e');
    }
  }

  /// Get a specific quiz by ID
  Future<Quiz?> getQuiz(String id) async {
    _ensureInitialized();
    try {
      final quizzes = await getQuizzes();
      return quizzes.firstWhere(
        (quiz) => quiz.id == id,
        orElse: () => null as Quiz,
      );
    } catch (e) {
      return null;
    }
  }

  /// Clear all quizzes
  Future<void> clearQuizzes() async {
    _ensureInitialized();
    try {
      await _prefs.remove(_quizzesKey);
    } catch (e) {
      throw Exception('Failed to clear quizzes: $e');
    }
  }

  // ==================== Utility Methods ====================

  /// Clear all data
  Future<void> clearAllData() async {
    _ensureInitialized();
    try {
      await Future.wait([
        clearChatHistory(),
        clearSummaries(),
        clearQuizResults(),
        clearQuizzes(),
      ]);
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }

  /// Get statistics about stored data
  Future<Map<String, int>> getStorageStats() async {
    _ensureInitialized();
    try {
      final chatCount = (await getChatHistory()).length;
      final summariesCount = (await getSummaries()).length;
      final quizzesCount = (await getQuizzes()).length;
      final resultsCount = (await getQuizResults()).length;

      return {
        'chat_entries': chatCount,
        'summaries': summariesCount,
        'quizzes': quizzesCount,
        'quiz_results': resultsCount,
      };
    } catch (e) {
      throw Exception('Failed to get storage stats: $e');
    }
  }
}
