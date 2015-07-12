//
//  SharedSettings.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/12/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySettings : NSObject {
  //int unitIsMile;
}

//@property int unitIsMile;

+ (id) sharedSetting;
- (void) setUnitIsMile:(int)unit;
- (int)  getUnitIsMile;

@end
