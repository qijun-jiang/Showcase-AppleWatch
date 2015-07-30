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
    }
    else {      
      if (replyInfo.count == 0) {
        [_nearestDescription setText:@"Sorry! We found no user for you."];
        [_fullListButton setHidden:YES];
        return;
      }
      else {
        NSDictionary * theCustomer = [replyInfo valueForKeyPath:[@(0) stringValue]];
        if (replyInfo.count == 1) {
          [_nearestDescription setText:[NSString stringWithFormat:@"The nearest customer is %@ away", [theCustomer objectForKey:@"distance"]]];
        }
        else {
          NSDictionary *anotherCustomer = [replyInfo valueForKeyPath:[@(replyInfo.count - 1) stringValue]];
          [_nearestDescription setText:[NSString stringWithFormat:@"The nearest %ld customers are from %@ to %@ away", replyInfo.count, [theCustomer objectForKey:@"distance"], [anotherCustomer objectForKey:@"distance"]]];
        }
      }
      
      _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
      [self.nearestFourTable setNumberOfRows:replyInfo.count withRowType:@"CustomerRow"];
      
      MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.05, 0.05);
      NSMutableArray * locations = [[NSMutableArray alloc] init];
      NSMutableArray * lat = [[NSMutableArray alloc] init];
      NSMutableArray * lon = [[NSMutableArray alloc] init];
      NSMutableArray * name = [[NSMutableArray alloc] init];
      CLLocationCoordinate2D Location;
      MKPointAnnotation * point;
      
      for (int i = 0; i < replyInfo.count; i++) {
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
  NSDictionary * theCustomer = [_customerList valueForKeyPath:[@(rowIndex) stringValue]];
  [self pushControllerWithName:@"PersonController" context:theCustomer];
}

@end



