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
  
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"byName", @"sortType", nil];
  int _unitIsMile = 0;

  
  
  // ----------------- Interface above ----------------------- //
  
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
      //double distance;
      NSDictionary *theCustomer;
      NSMutableArray *myItems = [[NSMutableArray alloc] init];
      
      for (PFObject *object in objects) {
        Location = [[CLLocation alloc] initWithLatitude:[object[@"Latitude"] floatValue] longitude:[object[@"Longitud"] floatValue]];
        distanceMeters = [currentLocation distanceFromLocation:Location];
        
        NSString * distanceStr;
        if (_unitIsMile == 0) {
          distanceStr = [NSString stringWithFormat:@"%.2f km", distanceMeters / 1000];
        }
        else {
          distanceStr = [NSString stringWithFormat:@"%.2f mi", distanceMeters / 1600];
        }
        
        /* NSString * distanceStr = [NSString stringWithFormat:@"%.2f", distance];
         if (distance > 1000) {
         distanceStr = @">1000";
         }*/
        
        theCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                       object[@"Name"], @"name",
                       object[@"Address"], @"address",
                       object[@"City"], @"city",
                       object[@"state"], @"state",
                       object[@"Latitude"], @"latitude",
                       object[@"Longitud"], @"longitude",
                       distanceStr, @"distance", nil];
        
        [myItems addObject:theCustomer];
      }
      
      /*
       -------------- Sort By different categories --------------
       */
      NSString * sortByStr;
      if ([[userInfo objectForKey:@"sortType"] isEqual:@"byName"]) {
        sortByStr = @"name";
      } else if ([[userInfo objectForKey:@"sortType"] isEqual:@"byState"]) {
        sortByStr = @"name";
      } else if ([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyFour"]) {
        sortByStr = @"distance";
      } else {
        NSLog(@"Doesn't recognize sort type.");
        assert(0);
      }
      
      // Sort this array with compare, Shiny Blocks!!!!
      NSArray *sortedArray;
      sortedArray = [myItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [[(NSDictionary*)a valueForKeyPath:sortByStr] uppercaseString];
        NSString *second = [[(NSDictionary*)b valueForKeyPath:sortByStr] uppercaseString];
        return [first compare:second];
      }];
      
      // Insert sorted Object into tempDictionary
      int sortCount = (int)[sortedArray count];
      if ([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyFour"]) {
        sortCount = 4 < (int)[sortedArray count] ? 4 : (int)[sortedArray count];
        for (int i = 0; i < sortCount; i++) {
          id myArrayElement = [sortedArray objectAtIndex:i];
          [tempDictionary setObject:myArrayElement forKey:[@(i) stringValue]];
        }
      }
      else {
        sortCount = (int)[sortedArray count];
        sortCount = 10;
        
        // ----------------- BEGIN: To be coded ------------------ //
        
        
        if ([[userInfo objectForKey:@"sortType"] isEqual:@"byName"]) {
          for (int i = 0; i < sortCount; i++) {
            id myArrayElement = [sortedArray objectAtIndex:i];
            
            NSString * firstLetter = [[[(NSDictionary*)myArrayElement valueForKeyPath:@"name"] substringToIndex:1] uppercaseString]; // All swtiched to upper case
            
            if ([tempDictionary objectForKey:firstLetter]) {
              // if exists such array, add element
              [[tempDictionary valueForKeyPath:firstLetter] addObject:myArrayElement];
            } else {
              // if NOT exists such array, create one
              NSMutableArray *arrayAtDict = [[NSMutableArray alloc] init];
              [arrayAtDict addObject:myArrayElement];
              [tempDictionary setObject:arrayAtDict forKey:firstLetter];
            }
          }

          
        } else {
          for (int i = 0; i < sortCount; i++) {
            id myArrayElement = [sortedArray objectAtIndex:i];
            id firstLetter = [[myArrayElement valueForKeyPath:@"state"] uppercaseString];
            
            if ([tempDictionary objectForKey:firstLetter]) {
              // if exists such array, add element
              [[tempDictionary valueForKeyPath:firstLetter] addObject:myArrayElement];
            } else {
              // if NOT exists such array, create one
              NSMutableArray *arrayAtDict = [[NSMutableArray alloc] init];
              [arrayAtDict addObject:myArrayElement];
              [tempDictionary setObject:arrayAtDict forKey:firstLetter];
            }
            
          }
          
        }
        
        
        
        
        // ----------------- END: To be coded ------------------ //
        
        
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
