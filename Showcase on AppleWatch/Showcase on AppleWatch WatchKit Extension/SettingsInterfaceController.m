//
//  SettingsInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/11/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "SettingsInterfaceController.h"

@interface SettingsInterfaceController ()
@property UIColor *originColor;
@property UIColor *selectedColor;
@property int prevUnit;
@end

@implementation SettingsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _selectedColor = [UIColor colorWithRed:100.0/255 green:221.0/255 blue:119.0/255 alpha:1];
    _originColor = [UIColor colorWithRed:39.0/255 green:39.0/255 blue:40.0/255 alpha:1];
    // Configure interface objects here.
    MySettings *sharedSetting = [MySettings sharedSetting];
  _prevUnit = [sharedSetting getUnitIsMile];
    if (_prevUnit == 0) {
      [self kmButtonClicked];
      [self distanceButtonClicked];
    }
    else {
      [self miButtonClicked];
    }
}
- (IBAction)kmButtonClicked {
  [_kmButton setBackgroundColor: _selectedColor];
  [_miButton setBackgroundColor: _originColor];
  MySettings *sharedSetting = [MySettings sharedSetting];
  [sharedSetting setUnitIsMile:0];
  if ([sharedSetting getUnitIsMile] != _prevUnit) {
    _prevUnit = 0;
    [WKInterfaceController openParentApplication:@{@"setUnitIsMile": @"0"} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
    }];
  }
}
- (IBAction)miButtonClicked {
  [_kmButton setBackgroundColor: _originColor];
  [_miButton setBackgroundColor: _selectedColor];
  MySettings *sharedSetting = [MySettings sharedSetting];
  [sharedSetting setUnitIsMile:1];
  if ([sharedSetting getUnitIsMile] != _prevUnit) {
    _prevUnit = 1;
    [WKInterfaceController openParentApplication:@{@"setUnitIsMile": @"1"} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
    }];
  }
}
- (IBAction)distanceButtonClicked {
  [_distanceButton setBackgroundColor: _selectedColor];
  [_timeButton setBackgroundColor: _originColor];
}
- (IBAction)timeButtonClicked {
  [_distanceButton setBackgroundColor: _originColor];
  [_timeButton setBackgroundColor: _selectedColor];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
  NSLog(@"deactivating.....");
}

@end



