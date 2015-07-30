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
    [_Name setText:[NSString stringWithFormat:@"%@", [theCustomer objectForKey:@"name"]]];
    [_Address setText:[NSString stringWithFormat:@"%@", [theCustomer objectForKey: @"address"]]];
    [_Distance setText:[NSString stringWithFormat:@"%@ away", [theCustomer objectForKey: @"distance"]]];
    // Configure interface objects here.
 
  if ([[theCustomer objectForKey: @"distance"] isEqual:@"unknown distance"]) {
    [self.MapView setHidden:YES];
    return;
  }
  
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
- (IBAction)nearbySegue {
  [self pushControllerWithName:@"NearbyController" context:nil];
}
- (IBAction)nameSegue {
  [self pushControllerWithName:@"ListController" context:@"byName"];
}
- (IBAction)stateSegue {
  [self pushControllerWithName:@"ListController" context:@"byState"];
}
- (IBAction)settingsSegue {
  [self pushControllerWithName:@"SettingsController" context:nil];
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



