abstract class ChainedStruct {
  const ChainedStruct({this.next});
  final ChainedStruct? next;

  int get sType;
}
