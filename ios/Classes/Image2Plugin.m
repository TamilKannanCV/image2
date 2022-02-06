#import "Image2Plugin.h"
#if __has_include(<image2/image2-Swift.h>)
#import <image2/image2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "image2-Swift.h"
#endif

@implementation Image2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImage2Plugin registerWithRegistrar:registrar];
}
@end
