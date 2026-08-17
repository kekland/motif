#include <stdint.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <AppKit/NSApplication.h>
#import <AppKit/NSWindow.h>
#import <AppKit/NSButton.h>
#import <AppKit/NSView.h>
#import <AppKit/NSLayoutConstraint.h>
#import <AppKit/NSLayoutAnchor.h>
#import <AppKit/NSTitlebarAccessoryViewController.h>
#import <AppKit/NSCursor.h>
#import <AppKit/NSImage.h>
#import <AppKit/NSImageRep.h>
#import <AppKit/NSBitmapImageRep.h>
#import <AppKit/NSHapticFeedback.h>

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

typedef struct {
  int64_t version;
  void* (*newWaiter)(void);
  void (*awaitWaiter)(void*);
  void* (*currentIsolate)(void);
  void (*enterIsolate)(void*);
  void (*exitIsolate)(void);
  int64_t (*getMainPortId)(void);
  bool (*getCurrentThreadOwnsIsolate)(int64_t);
  void (*invokeListenerPortBlock)(int64_t port, void*);
  void (*invokeBlockingPortBlock)(int64_t port, void*, void*);
} DOBJC_Context;

id objc_retainBlock(id);

#define BLOCKING_BLOCK_IMPL(ctx, TYPE, SIG, INVOKE_DIRECT, INVOKE_LISTENER)    \
  assert(ctx->version >= 1);                                                   \
  void* targetIsolate = ctx->currentIsolate();                                 \
  int64_t targetPort = ctx->getMainPortId == NULL ? 0 : ctx->getMainPortId();  \
  __block __weak TYPE weakSelfBlock = nil;                                     \
  TYPE strongSelfBlock = [SIG {                                                \
    void* currentIsolate = ctx->currentIsolate();                              \
    bool mayEnterIsolate =                                                     \
        currentIsolate == NULL &&                                              \
        ctx->getCurrentThreadOwnsIsolate != NULL &&                            \
        ctx->getCurrentThreadOwnsIsolate(targetPort);                          \
    if (currentIsolate == targetIsolate || mayEnterIsolate) {                  \
      if (mayEnterIsolate) {                                                   \
        ctx->enterIsolate(targetIsolate);                                      \
      }                                                                        \
      INVOKE_DIRECT;                                                           \
      if (mayEnterIsolate) {                                                   \
        ctx->exitIsolate();                                                    \
      }                                                                        \
    } else {                                                                   \
      void* waiter = ctx->newWaiter();                                         \
      TYPE selfRetain = [weakSelfBlock copy];                                  \
      INVOKE_LISTENER;                                                         \
      ctx->awaitWaiter(waiter);                                                \
      (void)selfRetain;                                                        \
    }                                                                          \
  } copy];                                                                     \
  weakSelfBlock = strongSelfBlock;                                             \
  return strongSelfBlock;


__attribute__((visibility("default"))) __attribute__((used))
Protocol* _k4vejs_NSHapticFeedbackPerformer(void) { return @protocol(NSHapticFeedbackPerformer); }

__attribute__((visibility("default")))
@interface _k4vejs_BlockArgs_1pl9qdv : NSObject
@property (copy) id block;

@end
@implementation _k4vejs_BlockArgs_1pl9qdv
@end

typedef void  (^_ListenerTrampoline)(void);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _k4vejs_wrapListenerBlock_1pl9qdv(
    int64_t port, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  __block __weak _ListenerTrampoline weakSelfBlock = nil;
  _ListenerTrampoline strongSelfBlock = [^void() {
    @autoreleasepool {
      _k4vejs_BlockArgs_1pl9qdv* args = [[_k4vejs_BlockArgs_1pl9qdv alloc] init];
      args.block = weakSelfBlock;
      
      ctx->invokeListenerPortBlock(port, (__bridge_retained void*)args);
    }
  } copy];
  weakSelfBlock = strongSelfBlock;
  return strongSelfBlock;
}

typedef void  (^_BlockingTrampoline)(void * waiter);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline _k4vejs_wrapBlockingBlock_1pl9qdv(int64_t port, DOBJC_Context* ctx,
    void (*directInvoke)(void*)) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, _ListenerTrampoline, ^void(), {
    @autoreleasepool {
      _k4vejs_BlockArgs_1pl9qdv* args = [[_k4vejs_BlockArgs_1pl9qdv alloc] init];
      args.block = weakSelfBlock;
      
      directInvoke((__bridge_retained void*)args);
    }
  }, {
    @autoreleasepool {
      _k4vejs_BlockArgs_1pl9qdv* args = [[_k4vejs_BlockArgs_1pl9qdv alloc] init];
      args.block = weakSelfBlock;
      
      ctx->invokeBlockingPortBlock(port, (__bridge_retained void*)args, waiter);
    }
  });
}

__attribute__((visibility("default")))
@interface _k4vejs_BlockArgs_xtuoz7 : NSObject
@property (copy) id block;
@property (strong) id arg0;
@end
@implementation _k4vejs_BlockArgs_xtuoz7
@end

typedef void  (^_ListenerTrampoline_1)(id arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_1 _k4vejs_wrapListenerBlock_xtuoz7(
    int64_t port, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  __block __weak _ListenerTrampoline_1 weakSelfBlock = nil;
  _ListenerTrampoline_1 strongSelfBlock = [^void(id arg0) {
    @autoreleasepool {
      _k4vejs_BlockArgs_xtuoz7* args = [[_k4vejs_BlockArgs_xtuoz7 alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      ctx->invokeListenerPortBlock(port, (__bridge_retained void*)args);
    }
  } copy];
  weakSelfBlock = strongSelfBlock;
  return strongSelfBlock;
}

typedef void  (^_BlockingTrampoline_1)(void * waiter, id arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_1 _k4vejs_wrapBlockingBlock_xtuoz7(int64_t port, DOBJC_Context* ctx,
    void (*directInvoke)(void*)) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, _ListenerTrampoline_1, ^void(id arg0), {
    @autoreleasepool {
      _k4vejs_BlockArgs_xtuoz7* args = [[_k4vejs_BlockArgs_xtuoz7 alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      directInvoke((__bridge_retained void*)args);
    }
  }, {
    @autoreleasepool {
      _k4vejs_BlockArgs_xtuoz7* args = [[_k4vejs_BlockArgs_xtuoz7 alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      ctx->invokeBlockingPortBlock(port, (__bridge_retained void*)args, waiter);
    }
  });
}

__attribute__((visibility("default")))
@interface _k4vejs_BlockArgs_t8l8el : NSObject
@property (copy) id block;
@property (strong) id arg0;
@property BOOL * arg1;
@end
@implementation _k4vejs_BlockArgs_t8l8el
@end

typedef void  (^_ListenerTrampoline_2)(id arg0, BOOL * arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_2 _k4vejs_wrapListenerBlock_t8l8el(
    int64_t port, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  __block __weak _ListenerTrampoline_2 weakSelfBlock = nil;
  _ListenerTrampoline_2 strongSelfBlock = [^void(id arg0, BOOL * arg1) {
    @autoreleasepool {
      _k4vejs_BlockArgs_t8l8el* args = [[_k4vejs_BlockArgs_t8l8el alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      ctx->invokeListenerPortBlock(port, (__bridge_retained void*)args);
    }
  } copy];
  weakSelfBlock = strongSelfBlock;
  return strongSelfBlock;
}

typedef void  (^_BlockingTrampoline_2)(void * waiter, id arg0, BOOL * arg1);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_2 _k4vejs_wrapBlockingBlock_t8l8el(int64_t port, DOBJC_Context* ctx,
    void (*directInvoke)(void*)) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, _ListenerTrampoline_2, ^void(id arg0, BOOL * arg1), {
    @autoreleasepool {
      _k4vejs_BlockArgs_t8l8el* args = [[_k4vejs_BlockArgs_t8l8el alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      directInvoke((__bridge_retained void*)args);
    }
  }, {
    @autoreleasepool {
      _k4vejs_BlockArgs_t8l8el* args = [[_k4vejs_BlockArgs_t8l8el alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      ctx->invokeBlockingPortBlock(port, (__bridge_retained void*)args, waiter);
    }
  });
}

__attribute__((visibility("default")))
@interface _k4vejs_BlockArgs_4sp4xj : NSObject
@property (copy) id block;
@property long arg0;
@end
@implementation _k4vejs_BlockArgs_4sp4xj
@end

typedef void  (^_ListenerTrampoline_3)(long arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_3 _k4vejs_wrapListenerBlock_4sp4xj(
    int64_t port, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  __block __weak _ListenerTrampoline_3 weakSelfBlock = nil;
  _ListenerTrampoline_3 strongSelfBlock = [^void(long arg0) {
    @autoreleasepool {
      _k4vejs_BlockArgs_4sp4xj* args = [[_k4vejs_BlockArgs_4sp4xj alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      ctx->invokeListenerPortBlock(port, (__bridge_retained void*)args);
    }
  } copy];
  weakSelfBlock = strongSelfBlock;
  return strongSelfBlock;
}

typedef void  (^_BlockingTrampoline_3)(void * waiter, long arg0);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_3 _k4vejs_wrapBlockingBlock_4sp4xj(int64_t port, DOBJC_Context* ctx,
    void (*directInvoke)(void*)) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, _ListenerTrampoline_3, ^void(long arg0), {
    @autoreleasepool {
      _k4vejs_BlockArgs_4sp4xj* args = [[_k4vejs_BlockArgs_4sp4xj alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      directInvoke((__bridge_retained void*)args);
    }
  }, {
    @autoreleasepool {
      _k4vejs_BlockArgs_4sp4xj* args = [[_k4vejs_BlockArgs_4sp4xj alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      ctx->invokeBlockingPortBlock(port, (__bridge_retained void*)args, waiter);
    }
  });
}

__attribute__((visibility("default")))
@interface _k4vejs_BlockArgs_gjex3c : NSObject
@property (copy) id block;
@property void * arg0;
@property NSHapticFeedbackPattern arg1;
@property NSHapticFeedbackPerformanceTime arg2;
@end
@implementation _k4vejs_BlockArgs_gjex3c
@end

typedef void  (^_ListenerTrampoline_4)(void * arg0, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_4 _k4vejs_wrapListenerBlock_gjex3c(
    int64_t port, DOBJC_Context* ctx) NS_RETURNS_RETAINED {
  __block __weak _ListenerTrampoline_4 weakSelfBlock = nil;
  _ListenerTrampoline_4 strongSelfBlock = [^void(void * arg0, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2) {
    @autoreleasepool {
      _k4vejs_BlockArgs_gjex3c* args = [[_k4vejs_BlockArgs_gjex3c alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      args.arg2 = arg2;
      ctx->invokeListenerPortBlock(port, (__bridge_retained void*)args);
    }
  } copy];
  weakSelfBlock = strongSelfBlock;
  return strongSelfBlock;
}

typedef void  (^_BlockingTrampoline_4)(void * waiter, void * arg0, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2);
__attribute__((visibility("default"))) __attribute__((used))
_ListenerTrampoline_4 _k4vejs_wrapBlockingBlock_gjex3c(int64_t port, DOBJC_Context* ctx,
    void (*directInvoke)(void*)) NS_RETURNS_RETAINED {
  BLOCKING_BLOCK_IMPL(ctx, _ListenerTrampoline_4, ^void(void * arg0, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2), {
    @autoreleasepool {
      _k4vejs_BlockArgs_gjex3c* args = [[_k4vejs_BlockArgs_gjex3c alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      args.arg2 = arg2;
      directInvoke((__bridge_retained void*)args);
    }
  }, {
    @autoreleasepool {
      _k4vejs_BlockArgs_gjex3c* args = [[_k4vejs_BlockArgs_gjex3c alloc] init];
      args.block = weakSelfBlock;
      args.arg0 = arg0;
      args.arg1 = arg1;
      args.arg2 = arg2;
      ctx->invokeBlockingPortBlock(port, (__bridge_retained void*)args, waiter);
    }
  });
}

typedef void  (^_ProtocolTrampoline)(void * sel, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2);
__attribute__((visibility("default"))) __attribute__((used))
void  _k4vejs_protocolTrampoline_gjex3c(id target, void * sel, NSHapticFeedbackPattern arg1, NSHapticFeedbackPerformanceTime arg2) {
  return ((_ProtocolTrampoline)((id (*)(id, SEL, SEL))objc_msgSend)(target, @selector(getDOBJCDartProtocolMethodForSelector:), sel))(sel, arg1, arg2);
}
#undef BLOCKING_BLOCK_IMPL

#pragma clang diagnostic pop
