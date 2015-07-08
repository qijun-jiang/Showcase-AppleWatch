//
//  NearbyMapController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/7/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NearbyMapController.h"

@interface NearbyMapController ()

@end

@implementation NearbyMapController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  [WKInterfaceController openParentApplication:@{@"getCustomers": @"NearbyMap"} reply:^(NSDictionary *replyInfo,   NSError *error) {
    if (error) {
      NSLog(@"---------------ERROR:%@", error);
    }
    else {
      NSLog(@"------------RIGHT!");

      MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.1, 0.1);
      NSMutableArray * locations = [[NSMutableArray alloc] init];
      NSMutableArray * lat = [[NSMutableArray alloc] init];
      NSMutableArray * lon = [[NSMutableArray alloc] init];
      NSMutableArray * name = [[NSMutableArray alloc] init];
      CLLocationCoordinate2D Location;
      MKPointAnnotation * point;
      
      
      for (int i = 0; i < replyInfo.count; i++) {
        NSDictionary * theCustomer = [[replyInfo allValues] objectAtIndex:i];
        [lat addObject:[theCustomer objectForKey:@"latitude"]];
        [lon addObject:[theCustomer objectForKey:@"longitude"]];
        [name addObject:[theCustomer objectForKey:@"name"]];
        
        point= [[MKPointAnnotation alloc] init];
        Location.latitude=[[lat objectAtIndex:i]floatValue];
        Location.longitude=[[lon objectAtIndex:i]floatValue];
        point.coordinate = Location;
        point.title = [name objectAtIndex:i];
       // point.subtitle = [subtitle1 objectAtIndex:x];
        [locations addObject:point];
        [self.CustomersMap addAnnotation:Location withPinColor: WKInterfaceMapPinColorRed];
      }
      [self.CustomersMap setRegion:(MKCoordinateRegionMake(Location, coordinateSpan))];
    }
  }];
  

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
- (IBAction)ShowinList {
  [self popController];
}

@end



