//
//  NearbyListController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/6/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NearbyListController.h"

@interface NearbyListController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *customerTable;
@property NSDictionary *customerList;

@end

@implementation NearbyListController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [WKInterfaceController openParentApplication:@{@"getCustomers": @"customerList",
                                                   @"sortType": @"nearbyAll"} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
      else {
        NSLog(@"------------RIGHT!");
        _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
        [self.customerTable setNumberOfRows:replyInfo.count withRowType:@"CustomerRow"];
        for (int i = 0; i < self.customerTable.numberOfRows; i++) {
          NSDictionary * theCustomer = [replyInfo valueForKeyPath:[@(i) stringValue]];
          CustomerRow* theRow = [self.customerTable rowControllerAtIndex:i];
          [theRow.Name setText:[theCustomer objectForKey:@"name"]];
          [theRow.Distance setText:[[theCustomer objectForKey:@"distance"] stringByAppendingString:@"》"]];
        }
      }
    }];
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



