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

@end

@implementation NearbyListController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [WKInterfaceController openParentApplication:@{@"action": @"getCustomerList"} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
      else {
        NSLog(@"------------RIGHT!");
        [self.customerTable setNumberOfRows:replyInfo.count withRowType:@"CustomerRow"];
        for (int i = 0; i < self.customerTable.numberOfRows; i++) {
          CustomerRow* theRow = [self.customerTable rowControllerAtIndex:i];
          [theRow.Name setText:[[replyInfo allKeys] objectAtIndex:i]];
        }
      }
    }];
  
  
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



