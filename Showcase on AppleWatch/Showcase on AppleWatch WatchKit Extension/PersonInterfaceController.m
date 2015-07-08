//
//  PersonInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/8/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "PersonInterfaceController.h"

@interface PersonInterfaceController ()

@end

@implementation PersonInterfaceController

- (void)awakeWithContext:(id)context {
    NSDictionary *theCustomer = [[NSDictionary alloc] initWithDictionary:context];
    [super awakeWithContext:context];
    [_Name setText:[NSString stringWithFormat:@"Name: %@", [theCustomer objectForKey:@"name"]]];
    [_Latitude setText:[NSString stringWithFormat:@"Latitude: %@", [theCustomer objectForKey: @"latitude"]]];
    [_Longitude setText:[NSString stringWithFormat:@"Longitude: %@", [theCustomer objectForKey: @"longitude"]]];
    [_Distance setText:[NSString stringWithFormat:@"Distance: %@ Mi", [theCustomer objectForKey: @"distance"]]];
    // Configure interface objects here.
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



