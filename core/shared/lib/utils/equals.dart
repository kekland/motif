import 'package:collection/collection.dart';

const _setEquality = SetEquality();
const _listEquality = ListEquality();
const _mapEquality = MapEquality();

bool setEquals<T>(Set<T> a, Set<T> b) => _setEquality.equals(a, b);
bool listEquals<T>(List<T> a, List<T> b) => _listEquality.equals(a, b);
bool mapEquals<K, V>(Map<K, V> a, Map<K, V> b) => _mapEquality.equals(a, b);

int setHash<T>(Set<T> set) => _setEquality.hash(set);
int listHash<T>(List<T> list) => _listEquality.hash(list);
int mapHash<K, V>(Map<K, V> map) => _mapEquality.hash(map);
