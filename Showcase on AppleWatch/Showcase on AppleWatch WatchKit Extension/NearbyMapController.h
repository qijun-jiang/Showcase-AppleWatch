//
//  NearbyMapController.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/7/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NearbyMapController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceMap *CustomersMap;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *ShowListButton;

@end
