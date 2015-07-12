//
//  NameInterfaceController.m
//  Showcase on AppleWatch
//
//  Created by Qijun on 7/9/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "ListInterfaceController.h"

@interface ListInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *characterTable;
@property NSDictionary *customerList;
@property int selectedRowIndex;
@property NSInteger minIndex;
@property NSInteger listLength;
@property NSString *interfceType;
@end

@implementation ListInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  
    _interfceType = context;
    _selectedRowIndex = -1;
  
    // Configure interface objects here.
    [WKInterfaceController openParentApplication:@{@"getCustomers": @"customerList",
                                                 @"sortType": _interfceType} reply:^(NSDictionary *replyInfo,   NSError *error) {
      if (error) {
        NSLog(@"---------------ERROR:%@", error);
      }
      else {
        NSLog(@"------------RIGHT!");
        _customerList = [[NSDictionary alloc] initWithDictionary:replyInfo copyItems:YES];
        [self.characterTable setNumberOfRows:replyInfo.count withRowType:@"CharacterRow"];
        for (int i = 0; i < replyInfo.count; i++) {
          CustomerRow *theRow = [self.characterTable rowControllerAtIndex:i];
          [theRow.Name setText:[[replyInfo allKeys] objectAtIndex:i] ];
          theRow.isCustomer = false;
          theRow.categoryName = [[replyInfo allKeys] objectAtIndex:i];
        }
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
  NSString *selectedRowName = selectedRow.categoryName;
  if (selectedRow.isCustomer == false) {
    NSLog(@"------notCustomer: theIndex = %ld, _selectedRowIndex = %d, min = %ld, length = %ld", (long)rowIndex, _selectedRowIndex, (long)_minIndex, (long)_listLength);
    NSIndexSet *indexes;
    if (_selectedRowIndex != -1) {
      indexes = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(_minIndex, _listLength)];
      [self.characterTable removeRowsAtIndexes:indexes];
    }
    if (_selectedRowIndex == rowIndex) {
      _selectedRowIndex = -1;
      return;
    }
    
    NSArray *thisCategory = [[NSArray alloc] initWithArray:[_customerList objectForKey:selectedRowName]];
    _selectedRowIndex = (int)rowIndex;
    if (_minIndex < rowIndex) {
      _minIndex = rowIndex + 1 - _listLength;
    }
    else {
      _minIndex = rowIndex + 1;
    }
    _listLength = thisCategory.count;
    indexes = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(_minIndex, _listLength)];
    
    [self.characterTable insertRowsAtIndexes:indexes withRowType:@"CustomerRow"];
    for (int i = 0; i < thisCategory.count; i++) {
      CustomerRow* theRow = [self.characterTable rowControllerAtIndex:i+_minIndex];
      NSDictionary * theCustomer = [thisCategory objectAtIndex:i];
      [theRow.Name setText:[theCustomer objectForKey:@"name"]];
      [theRow.Distance setText:[[theCustomer objectForKey:@"distance"] stringByAppendingString:@"》"]];
      theRow.categoryName = selectedRow.categoryName;
      theRow.categoryIndex = i;
    }
  }
  else {
    NSLog(@"-------Customer");
    NSIndexSet *indexes = [[NSIndexSet alloc]initWithIndexesInRange: NSMakeRange(_minIndex, _listLength)];
    [self.characterTable removeRowsAtIndexes:indexes];
    NSDictionary * theCustomer = [[_customerList valueForKey:selectedRow.categoryName] objectAtIndex:selectedRow.categoryIndex];
    [self pushControllerWithName:@"PersonController" context:theCustomer];
  }
}


@end



