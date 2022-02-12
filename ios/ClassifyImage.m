#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ClassifyImage, NSObject)

RCT_EXTERN_METHOD(request:(NSDictionary *)options
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(supportedIdentifiers:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

@end
