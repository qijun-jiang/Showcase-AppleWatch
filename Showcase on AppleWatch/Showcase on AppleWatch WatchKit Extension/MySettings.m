//
//  SharedSettings.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/12/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "MySettings.h"

@implementation MySettings

//@synthesize unitIsMile;
int unitIsMile;

+ (id) sharedSetting {
  static MySettings *sharedMySettings = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMySettings = [[self alloc] init];
  });
  return sharedMySettings;
}

- (void) setUnitIsMile:(int)unit {
  unitIsMile = unit;
}

- (int)  getUnitIsMile {
  return unitIsMile;
}

- (id)init {
  if (self = [super init]) {
    unitIsMile = 0;
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

@end
