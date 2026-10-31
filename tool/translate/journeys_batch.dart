// Adds Burmese texts to assets/content/journeys/journeys.json. A journey keeps
// every language in the `title`, `summary` and per-day `reflection` maps, so
// the result goes back into the same file. The texts are flattened to one ARB
// style map keyed `<journeyId>.title`, `<journeyId>.summary` and
// `<journeyId>.d<day>` so the ARB batch prompts and checks can be reused.
import 'arb_batch.dart';

const _lang = 'my';

Map<String, Object?> _map(Object? value) => value! as Map<String, Object?>;

/// One entry per translatable text: its key, its map and where the map lives.
Iterable<(String, Map<String, Object?>)> _texts(List<Object?> journeys) sync* {
  for (final journey in journeys) {
    final id = _map(journey)['id']! as String;
    yield ('$id.title', _map(_map(journey)['title']));
    yield ('$id.summary', _map(_map(journey)['summary']));
    for (final day in _map(journey)['daysPlan']! as List<Object?>) {
      yield ('$id.d${_map(day)['day']}', _map(_map(day)['reflection']));
    }
  }
}

/// The English texts keyed as described above.
ArbMap journeySource(List<Object?> journeys) => {
  for (final (key, text) in _texts(journeys)) key: text['en']! as String,
};

/// Keys that have no Burmese text yet (or all, with [force]), matching [only].
List<String> pendingJourneyTexts(
  List<Object?> journeys, {
  RegExp? only,
  bool force = false,
}) => [
  for (final (key, text) in _texts(journeys))
    if ((only == null || only.hasMatch(key)) &&
        (force || !text.containsKey(_lang)))
      key,
];

/// A copy of [journeys] with the Burmese texts in [done] added.
List<Object?> mergeJourneys(List<Object?> journeys, Map<String, String> done) {
  Map<String, Object?> withMy(String key, Map<String, Object?> text) => {
    ...text,
    if (done[key] != null) _lang: done[key],
  };
  return [
    for (final journey in journeys)
      {
        ..._map(journey),
        'title': withMy(
          '${_map(journey)['id']}.title',
          _map(_map(journey)['title']),
        ),
        'summary': withMy(
          '${_map(journey)['id']}.summary',
          _map(_map(journey)['summary']),
        ),
        'daysPlan': [
          for (final day in _map(journey)['daysPlan']! as List<Object?>)
            {
              ..._map(day),
              'reflection': withMy(
                '${_map(journey)['id']}.d${_map(day)['day']}',
                _map(_map(day)['reflection']),
              ),
            },
        ],
      },
  ];
}
