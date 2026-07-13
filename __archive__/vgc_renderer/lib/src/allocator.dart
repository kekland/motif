// import 'dart:collection';
// import 'package:wgpu/wgsl.dart' as wgsl;

// // /// A block-based GPU memory allocator.
// // class GpuBlockAllocator {}

// // class _BlockPool {
// //   _BlockPool({
// //     required this.blockSize,
// //     required this.maxBlocks,
// //   });

// //   final int blockSize;
// //   final int maxBlocks;
// //   final _freeBlocks = Queue<int>();

// //   int get availableBlocks => _freeBlocks.length;

// //   int blocksNeededFor(int count) {
// //     if (count == 0) return 0;
// //     return (count / blockSize).ceil();
// //   }

// //   List<int> allocate(int blockCount) {
// //     if (_freeBlocks.length < blockCount) throw Exception('out of blocks');
// //     return List.generate(blockCount, (_) => _freeBlocks.removeFirst());
// //   }

// //   void free(List<int> blocks) {
// //     _freeBlocks.addAll(blocks);
// //   }
// // }

// mixin GpuBlockAllocator on wgsl.ArrayStorageBuffer {

// }