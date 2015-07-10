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
    [_Address setText:[NSString stringWithFormat:@"Address: %@", [theCustomer objectForKey: @"address"]]];
    [_Distance setText:[NSString stringWithFormat:@"Distance: %@ Mi", [theCustomer objectForKey: @"distance"]]];
    // Configure interface objects here.
  
  MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
  NSMutableArray * locations = [[NSMutableArray alloc] init];
  CLLocationCoordinate2D Location;
  MKPointAnnotation * point;
    
  point= [[MKPointAnnotation alloc] init];
  Location.latitude=[[theCustomer objectForKey:@"latitude"]floatValue];
  Location.longitude=[[theCustomer objectForKey:@"longitude"] floatValue];
  point.coordinate = Location;
  [locations addObject:point];
  [self.MapView addAnnotation:Location withPinColor: WKInterfaceMapPinColorRed];
  [self.MapView setRegion:(MKCoordinateRegionMake(Location, coordinateSpan))];
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



