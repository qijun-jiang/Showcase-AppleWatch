//
//  NameInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/9/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "NameInterfaceController.h"

@interface NameInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *characterTable;
@property NSDictionary *customerList;
@property NSString *firstCh;
@property int selectedRowIndex;
@property NSInteger minIndex;
@property NSInteger listLength;
@end

@implementation NameInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  
    _firstCh = @"";
    _selectedRowIndex = -1;
    // Configure interface objects here.
    [WKInterfaceController openParentApplication:@{@"getCustomers": @"NearbyList",
                                                 @"sortType": @"NearbyAll"} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
      else {
        NSLog(@"------------RIGHT!");
        _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
        [self.characterTable setNumberOfRows:2 withRowType:@"CharacterRow"];
        CustomerRow* theRow = [self.characterTable rowControllerAtIndex:0];
        [theRow.Name setText:@"0-9"];
        theRow.isCustomer = false;
        theRow = [self.characterTable rowControllerAtIndex:1];
        [theRow.Name setText:@"A"];
        theRow.isCustomer = false;
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
  CustomerRow *selectedRow = [table rowControllerAtIndex:rowIndex];
  if (selectedRow.isCustomer == false) {
    NSLog(@"------notCustomer");
    NSIndexSet *indexes;
    if (_selectedRowIndex != -1) {
      indexes = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(_minIndex, _listLength)];
      [self.characterTable removeRowsAtIndexes:indexes];
    }
    if (_selectedRowIndex == rowIndex) {
      _selectedRowIndex = -1;
      return;
    }
    _selectedRowIndex = (int)rowIndex;
    _minIndex = rowIndex + 1;
    _listLength = _customerList.count;
    indexes = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(_minIndex, _listLength)];
    
    [self.characterTable insertRowsAtIndexes:indexes withRowType:@"CustomerRow"];
    for (int i = 0; i < _customerList.count; i++) {
      CustomerRow* theRow = [self.characterTable rowControllerAtIndex:i+rowIndex+1];
      NSDictionary * theCustomer = [[_customerList allValues] objectAtIndex:i];
      [theRow.Name setText:[theCustomer objectForKey:@"name"]];
      [theRow.Distance setText:[theCustomer objectForKey:@"distance"]];
    }
  }
  else {
    NSLog(@"-------Customer");
    NSDictionary * theCustomer = [[_customerList allValues] objectAtIndex:rowIndex];
    [self pushControllerWithName:@"PersonController" context:theCustomer];
  }
}


@end



