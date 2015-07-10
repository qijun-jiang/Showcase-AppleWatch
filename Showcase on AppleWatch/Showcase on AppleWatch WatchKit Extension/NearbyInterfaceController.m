//
//  NearbyInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/9/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NearbyInterfaceController.h"

@interface NearbyInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *distanceLabel;
@property NSDictionary *customerList;
@end

@implementation NearbyInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [WKInterfaceController openParentApplication:@{@"getCustomers": @"NearbyList",
                                                   @"sortType": @"NearbyFour"} reply:^(NSDictionary *replyInfo,   NSError *error) {
    if (error) {
      NSLog(@"---------------ERROR:%@", error);
    }
    else {
      NSLog(@"------------RIGHT!");
      _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
      [self.nearestFourTable setNumberOfRows:replyInfo.count withRowType:@"CustomerRow"];
      NSLog(@"num = %ld", (long)[_nearestFourTable numberOfRows]);
      
      MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
      NSMutableArray * locations = [[NSMutableArray alloc] init];
      NSMutableArray * lat = [[NSMutableArray alloc] init];
      NSMutableArray * lon = [[NSMutableArray alloc] init];
      NSMutableArray * name = [[NSMutableArray alloc] init];
      CLLocationCoordinate2D Location;
      MKPointAnnotation * point;
      
      for (int i = 0; i < replyInfo.count; i++) {
        NSDictionary * theCustomer = [[replyInfo allValues] objectAtIndex:i];
        CustomerRow* theRow = [self.nearestFourTable rowControllerAtIndex:i];
        
        if (i == 0) {
          [_nameLabel setText:[theCustomer objectForKey:@"name"]];
          [_distanceLabel setText:[NSString stringWithFormat:@"%@ mi away", [theCustomer objectForKey:@"distance"]]];
        }
        
        [theRow.Name setText:[theCustomer objectForKey:@"name"]];
        [theRow.Distance setText:[theCustomer objectForKey:@"distance"]];
        NSLog(@"name = %@, distance = %@", [theCustomer objectForKey:@"name"], [theCustomer objectForKey:@"distance"]);
        [lat addObject:[theCustomer objectForKey:@"latitude"]];
        [lon addObject:[theCustomer objectForKey:@"longitude"]];
        [name addObject:[theCustomer objectForKey:@"name"]];
        
        point = [[MKPointAnnotation alloc] init];
        Location.latitude=[[lat objectAtIndex:i]floatValue];
        Location.longitude=[[lon objectAtIndex:i]floatValue];
        point.coordinate = Location;
        point.title = [name objectAtIndex:i];
        [locations addObject:point];
        [self.theMap addAnnotation:Location withPinColor: WKInterfaceMapPinColorRed];
      }
      [self.theMap setRegion:(MKCoordinateRegionMake(Location, coordinateSpan))];
    }
  }];

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
  NSDictionary * theCustomer = [[_customerList allValues] objectAtIndex:rowIndex];
  [self pushControllerWithName:@"PersonController" context:theCustomer];
}

@end



