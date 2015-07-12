//
//  CustomerInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/6/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "MenuInterfaceController.h"

@interface MenuInterfaceController ()
@end

@implementation MenuInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
  
  MySettings *sharedSetting = [MySettings sharedSetting];
  [sharedSetting getUnitIsMile];
}

- (IBAction)nameButton {
  [self pushControllerWithName:@"ListController" context:@"byName"];
}
- (IBAction)provinceButton {
  [self pushControllerWithName:@"ListController" context:@"byState"];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


@end



