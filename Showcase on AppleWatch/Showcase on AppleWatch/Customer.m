//
//  Customer.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/7/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "Customer.h"

@implementation Customer

- (id) initWithName: (NSString *)theName
           Latitude: (float)theLat
         Longtitude: (float) theLon
           Distance: (double) theDistance{
  self = [super init];
  if (self) {
    _name = theName;
    _latitude = theLat;
    _longtitude = theLon;
  }
  return self;
}

@end
