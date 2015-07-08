//
//  Customer.h
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/7/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject

@property NSString * name;
@property float latitude;
@property float longtitude;
@property double distance;

- (id) initWithName: (NSString *)theName
           Latitude: (float)theLat
         Longtitude: (float) theLon
           Distance: (double) theDistance;

@end
