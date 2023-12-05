#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FlutterIcmpPingPlugin.h"
#import "GBPing.h"
#import "GBPingSummary.h"
#import "ICMPHeader.h"

FOUNDATION_EXPORT double flutter_icmp_pingVersionNumber;
FOUNDATION_EXPORT const unsigned char flutter_icmp_pingVersionString[];

