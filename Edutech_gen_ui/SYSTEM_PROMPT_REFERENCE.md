# System Prompt Integration Guide

## 📋 What's Included

Created: `lib/src/const/education_system_prompt.dart`

This file contains a comprehensive system prompt (385 lines, ~4,500 words) that guides the Gemini AI to:

1. **Act as an Education Tutor** - Never break character
2. **Analyze user knowledge level** - Basic, Intermediate, Advanced
3. **Provide structured explanations** - Matched to complexity level
4. **Suggest YouTube videos** - Specific, searchable queries
5. **Summarize video content** - With timestamps and key points
6. **Generate 5-question quizzes** - Varying cognitive levels
7. **Provide feedback** - Encouraging and constructive
8. **Output structured JSON** - For UI rendering

---

## 🔌 How to Use in Your App

### Step 1: Import the Prompt

```dart
import 'package:education_gen_ui/src/const/education_system_prompt.dart';
```

### Step 2: Pass to GenUI

In your chat page where you initialize `FirebaseAiContentGenerator`:

```dart
final contentGenerator = FirebaseAiContentGenerator(
  catalog: educationCatalog,
  systemInstruction: educationSystemPrompt,  // Add this
  additionalTools: [
    // Your custom tools
  ],
);
```

### Step 3: Full Integration Example

```dart
import 'package:education_gen_ui/src/const/education_system_prompt.dart';
import 'package:genui/genui.dart';
import 'package:genui_firebase_ai/genui_firebase_ai.dart';

class EducationChatPage extends StatefulWidget {
  @override
  State<EducationChatPage> createState() => _EducationChatPageState();
}

class _EducationChatPageState extends State<EducationChatPage> {
  late GenUiConversation _conversation;

  @override
  void initState() {
    super.initState();
    
    final genUiManager = GenUiManager(
      catalog: educationCatalog,
      configuration: const GenUiConfiguration(
        actions: ActionsConfig(
          allowCreate: true,
          allowUpdate: true,
          allowDelete: true,
        ),
      ),
    );

    final contentGenerator = FirebaseAiContentGenerator(
      catalog: educationCatalog,
      systemInstruction: educationSystemPrompt,  // ← System prompt
      additionalTools: [],
    );

    _conversation = GenUiConversation(
      genUiManager: genUiManager,
      contentGenerator: contentGenerator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Learn')),
      body: Column(
        children: [
          Expanded(
            child: Conversation(
              messages: _conversation.conversation.value,
              manager: _conversation.genUiManager,
            ),
          ),
          ChatInputField(
            onSubmit: (text) {
              _conversation.sendRequest(UserMessage.text(text));
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 📊 Prompt Structure

### 5-Stage Conversation Flow

| Stage | What Happens | AI Output | UI Element |
|-------|-------------|-----------|-----------|
| 1 | User asks question | Analyze level (basic/intermediate/advanced) | UserQueryBubble |
| 2 | AI provides explanation | Detailed explanation + YouTube search | AIExplanationBubble |
| 2 | Video search results | Embedded YouTube video | YouTubePlayerWidget |
| 3 | Optional video summary | Summary with key points | SummaryCard |
| 4 | Quiz generation | 5 multiple-choice questions | QuizCard |
| 5 | Quiz results | Score + answer review | QuizResultCard |

### JSON Output Format

The AI returns structured JSON with two main sections:

```json
{
  "tutorResponse": {
    "message": "Conversational text",
    "levelDetected": "basic|intermediate|advanced",
    "explanation": "Detailed explanation",
    "youtubeSearchQuery": "Video search phrase",
    "relatedTopics": ["Topic1", "Topic2", "Topic3"]
  },
  "quiz": {
    "topic": "Quiz topic",
    "questions": [
      {
        "id": "q1",
        "text": "Question?",
        "options": ["A", "B", "C", "D"],
        "correctIndex": 0,
        "explanation": "Why correct",
        "hints": "Optional hint"
      }
    ]
  }
}
```

---

## 🎯 Key Features

### 1. Level Detection

**The prompt automatically detects:**

- **Basic**: "What's AI?", "How do computers learn?"
  - Response: Simple metaphors, everyday examples
  - YouTube: Beginner-friendly terms

- **Intermediate**: "What's the difference between supervised and unsupervised learning?"
  - Response: Technical details, some jargon
  - YouTube: Standard technical terminology

- **Advanced**: "How does backpropagation compute gradients through non-convex loss landscapes?"
  - Response: Advanced math, research concepts
  - YouTube: Precise technical terminology

### 2. Consistent Complexity

The prompt ensures:
- ✅ YouTube searches match the level
- ✅ Explanations stay at the same level
- ✅ Quiz questions scale appropriately
- ✅ Related topics are at the same level

### 3. Quiz Quality

**5-Question Structure:**
- Q1: Basic recall
- Q2: Application
- Q3: Differentiation
- Q4: Analysis
- Q5: Synthesis/Advanced

**Each question has:**
- Clear, unambiguous text
- 4 options (1 correct, 1 incomplete, 1 misconception, 1 distractor)
- Detailed explanation
- Optional hint

### 4. YouTube Integration

**Specific search queries:**
- ✅ "Python lists tutorial for beginners"
- ✅ "Machine learning hyperparameter tuning"
- ✅ "GRU LSTM vanishing gradient comparison"

❌ NOT generic like "learn about Python"

---

## 🔧 Customization

### To Modify the Prompt

Edit `lib/src/const/education_system_prompt.dart`:

1. Change complexity levels
2. Add new error handling cases
3. Adjust quiz structure
4. Modify response format
5. Add new UI elements

**After modifying:**
```bash
# Rebuild the app for changes to take effect
flutter pub get
```

### To Add Custom Requirements

Add a new section in the prompt:

```dart
const String educationSystemPrompt = '''
# ... existing content ...

## New Section: Your Custom Rule

Your instruction here...
''';
```

---

## ✅ Testing the Prompt

### Test 1: Basic Level Question

```
User: "What's artificial intelligence?"
Expected:
- Level detected: "basic"
- Explanation: Simple, metaphor-based
- YouTube query: "Artificial intelligence for beginners"
- Quiz: Easy recall questions
```

### Test 2: Advanced Level Question

```
User: "Explain the transformer architecture's self-attention mechanism"
Expected:
- Level detected: "advanced"
- Explanation: Mathematical, technical
- YouTube query: "Transformer self-attention mechanism"
- Quiz: Complex analysis questions
```

### Test 3: Video Summary

```
User: (Provides YouTube link)
Expected:
- Summary with key concepts
- Timestamps if possible
- Bridge to quiz
```

---

## 🎓 Example Interactions

### Example 1: Basic Question

**User Input:** "What's a variable in Python?"

**AI Generates:**
```json
{
  "tutorResponse": {
    "message": "Great question! Variables are one of the building blocks of programming.",
    "levelDetected": "basic",
    "explanation": "A variable is like a labeled box that holds information. In Python, you give the box a name (like 'age' or 'name'), and put a value inside it (like 25 or 'Alice'). You can use this name later to get the value back. For example: age = 25 means 'create a box called age and put the number 25 inside it.'",
    "youtubeSearchQuery": "Python variables for beginners",
    "relatedTopics": [
      "Data types in Python",
      "Naming variables correctly",
      "Variable assignment operators"
    ]
  },
  "quiz": {
    "topic": "Python Variables",
    "questions": [
      {
        "id": "q1",
        "text": "What is a variable?",
        "options": [
          "A labeled container that holds a value",
          "A type of loop",
          "A mathematical function",
          "A string of text"
        ],
        "correctIndex": 0,
        "explanation": "A variable is exactly like a labeled box that stores data you want to use later.",
        "hints": "Think about the box analogy"
      }
    ]
  }
}
```

**User sees:**
1. AIExplanationBubble with the explanation
2. YouTubePlayerWidget with "Python variables for beginners"
3. SummaryCard with related topics
4. QuizCard with 5 questions

---

## 🚀 Next Steps

1. ✅ System prompt created
2. ⬜ Integrate into GenUI conversation page
3. ⬜ Test with basic questions
4. ⬜ Build GenUI catalog items (Phase 2)
5. ⬜ Connect to YouTube API/backend
6. ⬜ Test end-to-end flow

---

## 📚 Files in This Phase

- ✅ `lib/src/const/education_system_prompt.dart` - Main prompt
- ✅ `SYSTEM_PROMPT_REFERENCE.md` - This file

---

## 🔗 Related Files

- `PHASE_1_SETUP.md` - Data models and storage
- `PHASE_1_QUICKSTART.md` - Quick code examples
- Implementation plan (from Warp Drive)

---

## 💡 Pro Tips

1. **Keep the prompt fresh** - It can be regenerated/updated as needed
2. **Test incrementally** - Start with basic questions, then advanced
3. **Monitor JSON output** - Ensure it's valid before rendering
4. **Validate quiz questions** - Make sure no multiple correct answers
5. **Use related topics** - Leverage them for follow-up suggestions

---

## ❓ FAQ

**Q: Can I change the complexity levels?**
A: Yes! Edit the prompt to add new levels or modify thresholds.

**Q: What if the AI doesn't follow the JSON format?**
A: Add explicit instructions or use few-shot examples in the prompt.

**Q: How do I handle off-topic questions?**
A: The prompt includes error handling for this case.

**Q: Can I add more questions to the quiz?**
A: Yes, modify "Exactly 5 Multiple-Choice Questions" to any number.

**Q: What about video timestamps?**
A: The prompt suggests including them - extract from video metadata.

---

## 📞 Support

For integration help:
1. Check `PHASE_1_SETUP.md` for data model setup
2. Review `SYSTEM_PROMPT_REFERENCE.md` (this file)
3. See implementation plan in Warp Drive notebook
4. Test with example questions above

---

**Status**: ✅ System Prompt Complete  
**Next Phase**: GenUI Catalog Items (Phase 2)
