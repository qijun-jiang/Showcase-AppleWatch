//
//  ViewController.m
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/2/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@import CoreLocation;


@interface ViewController ()

@end

@implementation ViewController

//@synthesize myLabel;
@synthesize myTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
  // Kick off a heavy network request :)
  PFQuery *query = [PFQuery queryWithClassName:@"location"];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary * replyInfo;
    
    
    if (!error) {
      
//      CLLocationManager *lm = [[CLLocationManager alloc] init];
//      lm.delegate = self;
//      lm.desiredAccuracy = kCLLocationAccuracyBest;
//      lm.distanceFilter = kCLHeadingFilterNone;
//      [lm requestWhenInUseAuthorization];
//      [lm startUpdatingLocation];
//      CLLocation *currentLocation = [lm location];
      
      // temportary solution, Since we can't get the current location
      CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[@"31.236329" floatValue] longitude:[@"121.484939" floatValue]];
      
      CLLocation * Location;
      double distanceMeters;
      double distanceMiles;
      NSDictionary *theCustomer;
      NSMutableArray *myItems = [[NSMutableArray alloc] init];
      
      for (PFObject *object in objects) {
        NSString *tempstr1 = object.objectId;
        Location = [[CLLocation alloc] initWithLatitude:[object[@"Latitude"] floatValue] longitude:[object[@"Longitud"] floatValue]];
        distanceMeters = [currentLocation distanceFromLocation:Location];
        distanceMiles = distanceMeters / 1600;
        NSString * distanceStr;
        if (distanceMiles > 1000) {
          distanceStr = @">1000";
        }
        else {
          distanceStr= [NSString stringWithFormat:@"%.2f", distanceMiles];
        }
        theCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                       object[@"Name"], @"name",
                       object[@"Latitude"], @"latitude",
                       object[@"Longitud"], @"longitude",
                       distanceStr, @"distance", nil];
        
        [myItems addObject:theCustomer];
//        [tempDictionary setObject:theCustomer forKey:tempstr1];
      }
      
      // Sort this array with compare, Shiny Blocks!!!!
      NSArray *sortedArray;
      sortedArray = [myItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSDictionary*)a valueForKeyPath:@"distance"];
        NSString *second = [(NSDictionary*)b valueForKeyPath:@"distance"];
        
        return [first compare:second];
      }];
      
      // Insert Object into tempDictionary
      for (int i = 0; i < [sortedArray count]; i++) {
        id myArrayElement = [sortedArray objectAtIndex:i];
        [tempDictionary setObject:myArrayElement forKey:[@(i) stringValue]];
      }
      
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    replyInfo = [NSDictionary dictionaryWithDictionary:tempDictionary];
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
