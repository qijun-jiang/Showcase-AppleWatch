//
//  NearbyInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/9/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NearbyInterfaceController.h"

@interface NearbyInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *nearestDescription;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *fullListButton;
@property NSDictionary *customerList;
@end

@implementation NearbyInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    [WKInterfaceController openParentApplication:@{@"getCustomers": @"customerList",
                                                   @"sortType": @"nearbyFour"} reply:^(NSDictionary *replyInfo,   NSError *error) {
    if (error) {
      NSLog(@"---------------ERROR:%@", error);
      [_nearestDescription setText:@"Error in retrieving data, please try again"];
    }
    else {
      // different start information for different number of customers
      if (replyInfo.count == 1) {
        [_nearestDescription setText:@"Sorry! We found no user for you."];
        [_fullListButton setHidden:YES];
        return;
      }
      else {
        NSDictionary * theCustomer = [replyInfo valueForKeyPath:[@(0) stringValue]];
        if (replyInfo.count == 2) {
          [_nearestDescription setText:[NSString stringWithFormat:@"The nearest customer is %@ away", [theCustomer objectForKey:@"distance"]]];
        }
        else {
          NSDictionary *anotherCustomer = [replyInfo valueForKeyPath:[@(replyInfo.count - 2) stringValue]];
          [_nearestDescription setText:[NSString stringWithFormat:@"The nearest %ld customers are from %@ to %@ away", (unsigned long)replyInfo.count-1, [theCustomer objectForKey:@"distance"], [anotherCustomer objectForKey:@"distance"]]];
        }
      }
      
      // Put customers' information on table and map
      _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
      [self.nearestFourTable setNumberOfRows:replyInfo.count - 1 withRowType:@"CustomerRow"];
      
      MKCoordinateSpan coordinateSpan;
      NSMutableArray * lat = [[NSMutableArray alloc] init];
      NSMutableArray * lon = [[NSMutableArray alloc] init];
      CLLocationCoordinate2D Location;
      MKPointAnnotation * point;
      float minLat;
      float maxLat;
      float minLon;
      float maxLon;
      
      // Show the current location of the user on map
      NSDictionary * theCustomer = [replyInfo valueForKeyPath:[@(replyInfo.count - 1) stringValue]];
      [lat addObject:[theCustomer objectForKey:@"latitude"]];
      [lon addObject:[theCustomer objectForKey:@"longitude"]];
      
      point = [[MKPointAnnotation alloc] init];
      Location.latitude=[[lat objectAtIndex:lat.count-1] floatValue];
      Location.longitude=[[lon objectAtIndex:lon.count-1] floatValue];
      minLat = maxLat = Location.latitude;
      minLon = maxLon = Location.longitude;
      point.coordinate = Location;
      [self.theMap addAnnotation:Location withPinColor: WKInterfaceMapPinColorGreen];
      
      // Show the locations of users
      for (int i = 0; i < replyInfo.count - 1; i++) {
        NSDictionary * theCustomer = [replyInfo valueForKeyPath:[@(i) stringValue]];
        CustomerRow * theRow = [self.nearestFourTable rowControllerAtIndex:i];
        
        [theRow.Name setText:[theCustomer objectForKey:@"name"]];
        [theRow.Distance setText:[[theCustomer objectForKey:@"distance"] stringByAppendingString:@"》"]];
        
        if ([[theCustomer objectForKey:@"distance"] isEqual:@"unknown distance"])
        {
          continue;
        }
        
        [lat addObject:[theCustomer objectForKey:@"latitude"]];
        [lon addObject:[theCustomer objectForKey:@"longitude"]];
        
        point = [[MKPointAnnotation alloc] init];
        Location.latitude=[[lat objectAtIndex:i+1]floatValue];
        Location.longitude=[[lon objectAtIndex:i+1]floatValue];
        
        if (Location.latitude > maxLat) {
          maxLat = Location.latitude;
        } else if (Location.latitude < minLat) {
          minLat = Location.latitude;
        }
        if (Location.longitude > maxLon) {
          maxLon = Location.longitude;
        } else if (Location.longitude < minLon) {
          minLon = Location.longitude;
        }
        
        point.coordinate = Location;
        [self.theMap addAnnotation:Location withPinColor: WKInterfaceMapPinColorRed];
      }
      coordinateSpan = MKCoordinateSpanMake((maxLat - minLat) * 2.5, (maxLon - minLon) * 2.5);
      Location.latitude=[[lat objectAtIndex:0] floatValue];
      Location.longitude=[[lon objectAtIndex:0] floatValue];
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
  // send the customer information to PersonInterfaceController
  NSDictionary * theCustomer = [_customerList valueForKeyPath:[@(rowIndex) stringValue]];
  NSDictionary * theUser = [_customerList valueForKeyPath:[@(_customerList.count - 1) stringValue]];
  
  NSDictionary * newCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                                theCustomer[@"name"], @"name",
                                theCustomer[@"address"], @"address",
                                theCustomer[@"state"], @"state",
                                theCustomer[@"latitude"], @"latitude",
                                theCustomer[@"longitude"], @"longitude",
                                theCustomer[@"distance"], @"distance",
                                theUser[@"latitude"], @"userLatitude",
                                theUser[@"longitude"], @"userLongitude", nil];
  [self pushControllerWithName:@"PersonController" context:newCustomer];
}

@end



