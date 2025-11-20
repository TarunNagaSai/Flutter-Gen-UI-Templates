import 'package:education_gen_ui/src/catalogs/quiz_card_widget.dart';
import 'package:genui/genui.dart';

/// Defines the collection of UI components that the generative AI model can use
/// to construct the user interface for the travel app.
///
/// This catalog includes a mix of core widgets (like [CoreCatalogItems.column]
/// and [CoreCatalogItems.text]) and custom, domain-specific widgets tailored
/// for a travel planning experience, such as [travelCarousel], [itinerary],
/// and [inputGroup]. The AI selects from these components to build a dynamic
/// and interactive UI in response to user prompts.
final Catalog travelAppCatalog = CoreCatalogItems.asCatalog()
    .copyWithout([
      CoreCatalogItems.audioPlayer,
      CoreCatalogItems.card,
      CoreCatalogItems.checkBox,
      CoreCatalogItems.dateTimeInput,
      CoreCatalogItems.divider,
      CoreCatalogItems.textField,
      CoreCatalogItems.list,
      CoreCatalogItems.modal,
      CoreCatalogItems.multipleChoice,
      CoreCatalogItems.slider,
      CoreCatalogItems.tabs,
      CoreCatalogItems.video,
      CoreCatalogItems.icon,
      CoreCatalogItems.row,
      CoreCatalogItems.image,
    ])
    .copyWith([CoreCatalogItems.imageFixedSize, quizCardWidgetCatalogItem]);
