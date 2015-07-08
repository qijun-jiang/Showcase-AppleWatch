//
//  PersonInterfaceController.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/8/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface PersonInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Name;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Latitude;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Longitude;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Distance;

@end
