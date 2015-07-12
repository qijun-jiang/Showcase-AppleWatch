//
//  SettingsInterfaceController.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/11/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "MySettings.h"

@interface SettingsInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceButton *kmButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *miButton;

@end
