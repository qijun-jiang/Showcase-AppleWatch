//
//  ViewController.m
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/2/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

//@synthesize myLabel;
@synthesize myTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
  NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
  __block NSString *tempstr;
  
  
  PFQuery *query = [PFQuery queryWithClassName:@"star_loc"];
  //    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
  
  //    __block int i = 0;
  
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      // The find succeeded.
      NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
      
      // Do something with the found objects
      for (PFObject *object in objects) {
        //          NSLog(@"%@", object.objectId);
        
        //          NSString *tempstr = object.objectId;
        tempstr = object.objectId;
        
        [tempDictionary setObject:object forKey:tempstr];
        
        //          i++;
        
      }
      
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
  }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
    
    NSString* myString=[myTextField text];
    self.myLabel.text = myString;
    
}


@end
