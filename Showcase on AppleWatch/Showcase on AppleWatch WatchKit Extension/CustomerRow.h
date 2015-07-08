 //
//  CustomerRow.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/6/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface CustomerRow : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Name;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *Distance;

@end
