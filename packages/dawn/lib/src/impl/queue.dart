part of '../src.dart';
// ignore_for_file: unused_element

class Queue extends _Queue {
  Queue._(super.ptr) : super._();
  Queue._borrowed(super.ptr) : super._borrowed();

  void copyExternalTextureForBrowser(ImageCopyExternalTexture source, TexelCopyTextureInfo destination, Extent3D copySize, CopyTextureForBrowserOptions options) => _queueCopyExternalTextureForBrowser(this, source, destination, copySize, options);
  void copyTextureForBrowser(TexelCopyTextureInfo source, TexelCopyTextureInfo destination, Extent3D copySize, CopyTextureForBrowserOptions options) => _queueCopyTextureForBrowser(this, source, destination, copySize, options);
  Future<void> onSubmittedWorkDone() => _queueOnSubmittedWorkDone(this);
  void setLabel(String label) => _queueSetLabel(this, label);
  void submit(List<CommandBuffer> commandBuffers) => _queueSubmit(this, commandBuffers);

  // write_buffer, write_texture


}
