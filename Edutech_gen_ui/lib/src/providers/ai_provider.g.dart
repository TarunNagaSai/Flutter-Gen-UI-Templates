// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiChat)
const aiChatProvider = AiChatProvider._();

final class AiChatProvider extends $AsyncNotifierProvider<AiChat, AiChatState> {
  const AiChatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiChatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiChatHash();

  @$internal
  @override
  AiChat create() => AiChat();
}

String _$aiChatHash() => r'b5a99798627e7244872348735fcf098d6414ff86';

abstract class _$AiChat extends $AsyncNotifier<AiChatState> {
  FutureOr<AiChatState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AiChatState>, AiChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiChatState>, AiChatState>,
              AsyncValue<AiChatState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
