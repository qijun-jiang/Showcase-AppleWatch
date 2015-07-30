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
  
  // Get the data from last interface through segue
  NSDictionary *theCustomer = [[NSDictionary alloc] initWithDictionary:context];
  [super awakeWithContext:context];
  [_Name setText:[NSString stringWithFormat:@"%@", [theCustomer objectForKey:@"name"]]];
  [_Address setText:[NSString stringWithFormat:@"%@", [theCustomer objectForKey: @"address"]]];
  [_Distance setText:[NSString stringWithFormat:@"%@ away", [theCustomer objectForKey: @"distance"]]];
 
  // Hide the map when there is no latitude and longitude information
  if ([[theCustomer objectForKey: @"distance"] isEqual:@"unknown distance"]) {
    [self.MapView setHidden:YES];
    return;
  }
  
  // Show the location on map for navigation
  MKCoordinateSpan coordinateSpan;
  CLLocationCoordinate2D LocationCustomer;
  CLLocationCoordinate2D LocationUser;
  MKPointAnnotation * point;
    
  point = [[MKPointAnnotation alloc] init];
  // Set customer location on map
  LocationCustomer.latitude=[[theCustomer objectForKey:@"latitude"]floatValue];
  LocationCustomer.longitude=[[theCustomer objectForKey:@"longitude"] floatValue];
  point.coordinate = LocationCustomer;
  [self.MapView addAnnotation:LocationCustomer withPinColor: WKInterfaceMapPinColorRed];
  // Set user location on map
  LocationUser.latitude=[[theCustomer objectForKey:@"userLatitude"]floatValue];
  LocationUser.longitude=[[theCustomer objectForKey:@"userLongitude"] floatValue];
  point.coordinate = LocationUser;
  [self.MapView addAnnotation:LocationUser withPinColor: WKInterfaceMapPinColorGreen];
  
  coordinateSpan = MKCoordinateSpanMake(fabs(LocationUser.latitude - LocationCustomer.latitude) * 2.5, fabs(LocationUser.longitude - LocationCustomer.longitude) * 2.5);
  [self.MapView setRegion:(MKCoordinateRegionMake(LocationCustomer, coordinateSpan))];
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



