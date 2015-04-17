//
// DCARCMacros.h
//
// The code is free and can be used for any purpose including commercial purposes.
//

#if !defined(__clang__) || __clang_major__ < 3
#ifndef __bridge
#define __bridge
#endif

#ifndef __bridge_retain
#define __bridge_retain
#endif

#ifndef __bridge_retained
#define __bridge_retained
#endif

#ifndef __autoreleasing
#define __autoreleasing
#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

#ifndef DC_STRONG
#if __has_feature(objc_arc)
#define DC_STRONG strong
#else
#define DC_STRONG retain
#endif
#endif

#ifndef DC_WEAK
#if __has_feature(objc_arc_weak)
#define DC_WEAK weak
#elif __has_feature(objc_arc)
#define DC_WEAK unsafe_unretained
#else
#define DC_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define DC_SAFE_ARC_PROP_RETAIN strong
#define DC_SAFE_ARC_RETAIN(x) (x)
#define DC_SAFE_ARC_RELEASE(x)
#define DC_SAFE_ARC_AUTORELEASE(x) (x)
#define DC_SAFE_ARC_BLOCK_COPY(x) (x)
#define DC_SAFE_ARC_BLOCK_RELEASE(x)
#define DC_SAFE_ARC_SUPER_DEALLOC()
#define DC_SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
#define DC_SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define DC_SAFE_ARC_PROP_RETAIN retain
#define DC_SAFE_ARC_RETAIN(x) ([(x) retain])
#define DC_SAFE_ARC_RELEASE(x) ([(x) release],x = nil)
#define DC_SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
#define DC_SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
#define DC_SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define DC_SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#define DC_SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define DC_SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif
