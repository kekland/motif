part of '../webgpu.g.dart';
// ignore_for_file: unused_element

mixin _QueueImpl on _QueueBase {
  Future<void> onSubmittedWorkDone() => _onSubmittedWorkDoneImpl();
  void onSubmittedWorkDoneSync() => _onSubmittedWorkDoneSyncImpl();

  set label(String label) => _setLabelImpl(label);
  void submit(List<CommandBuffer> commandBuffers) => _submitImpl(commandBuffers);

  void writeBuffer(Buffer buffer, int bufferOffset, TypedData data) {
    using((allocator) {
      final dataPtr = allocator.allocate<ffi.Uint8>(data.lengthInBytes);
      final dataList = data.buffer.asUint8List();
      dataPtr.asTypedList(data.lengthInBytes).setAll(0, dataList);
      _writeBufferImpl(buffer, bufferOffset, dataPtr.cast(), data.lengthInBytes);
    });
  }
}
