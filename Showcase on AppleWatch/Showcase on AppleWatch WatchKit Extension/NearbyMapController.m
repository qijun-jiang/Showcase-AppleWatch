//
//  WKInterfaceController+NearbyMapController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 6/27/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NearbyMapController.h"

@implementation NearbyMapController

- (IBAction)ShowinList {
  //NSDictionary *appData = [[NSDictionary alloc] initWithObjects:@"new" forKeys:@[@"aaa"]];
  [WKInterfaceController openParentApplication:@{@"action": @"getUserCount"} reply:^(NSDictionary *replyInfo, NSError *error) {
    if (error) {
      NSLog(@"---------------ERROR!");
    }
    else
      NSLog(@"------------------%@ %@", replyInfo, error);
  }];
  
  //[_ShowListButton setTitle:[appData objectForKey:@"aaa"]];
}

@end
