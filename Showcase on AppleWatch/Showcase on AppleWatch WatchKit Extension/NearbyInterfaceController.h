//
//  NearbyInterfaceController.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/9/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "CustomerRow.h"

@interface NearbyInterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceMap *theMap;
@property (weak, nonatomic) IBOutlet WKInterfaceTable *nearestFourTable;

@end
