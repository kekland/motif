part of '_program.dart';

abstract final class ProgramCodec {
  static gen.Program encodeProgram(Program program) => codec.programCodec.encode(program);
  static Program decodeProgram(gen.Program program) => codec.programCodec.decode(program);

  static gen.ProgramSlice encodeProgramSlice(ProgramSlice programSlice) => codec.programSliceCodec.encode(programSlice);
  static ProgramSlice decodeProgramSlice(gen.ProgramSlice programSlice) => codec.programSliceCodec.decode(programSlice);

  static gen.ProgramDelta encodeProgramDelta(ProgramDelta programDelta) => codec.programDeltaCodec.encode(programDelta);
  static ProgramDelta decodeProgramDelta(gen.ProgramDelta programDelta) => codec.programDeltaCodec.decode(programDelta);

  static T? decodeRaw<T>(T Function() decode) {
    try {
      return decode();
    } catch (e) {
      return null;
    }
  }
}

extension ProgramEncode on Program {
  gen.Program encode() => ProgramCodec.encodeProgram(this);
}

extension ProgramSliceEncode on ProgramSlice {
  gen.ProgramSlice encode() => ProgramCodec.encodeProgramSlice(this);
}

extension ProgramDeltaEncode on ProgramDelta {
  gen.ProgramDelta encode() => ProgramCodec.encodeProgramDelta(this);
}
