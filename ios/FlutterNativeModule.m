//
//  FlutterNativeModule.m
//  rn_project
//
//  Created by Biswajit Paul on 31/01/25.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(FlutterNativeModule, NSObject)

RCT_EXTERN_METHOD(showToast:(NSString *)token userID:(NSString *)userID)

@end

