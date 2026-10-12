part of '_program.dart';

abstract final class ProgramCodec {
  static gen.Program encodeProgram(Program program) => program.encode();
  static Program decodeProgram(gen.Program program) => program.decode();

  static gen.ProgramSlice encodeProgramSlice(ProgramSlice programSlice) => programSlice.encode();
  static ProgramSlice decodeProgramSlice(gen.ProgramSlice programSlice) => programSlice.decode();

  static gen.ProgramDelta encodeProgramDelta(ProgramDelta programDelta) => programDelta.encode();
  static ProgramDelta decodeProgramDelta(gen.ProgramDelta programDelta) => programDelta.decode();
}
