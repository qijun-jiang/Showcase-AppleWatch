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

  // --------------------URL Request--------------------------//
  NSString *post = [[NSString alloc] initWithFormat:@"{\"root\": {\"parameters\": {\"clientId\"=\"logic091312\", \"methodName\":\"queryCustomerWithAddress\"}}}"];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:@"http://www.logicsolutions.com.cn:58080/ShowcaseSaas_cn2.6/SyncServer"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:postData];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  
  // start retrieve data, in block
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    NSDictionary * replyInfo;
    
    if (!error) {
      //NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      NSArray *customers = [[NSArray alloc] initWithArray:[[dictionary objectForKey:@"content"] objectForKey:@"customer"]];
      
//      CLLocationManager *lm = [[CLLocationManager alloc] init];
//      lm.delegate = self;
//      lm.desiredAccuracy = kCLLocationAccuracyBest;
//      lm.distanceFilter = kCLHeadingFilterNone;
//      [lm requestWhenInUseAuthorization];
//      [lm startUpdatingLocation];
//      CLLocation *currentLocation = [lm location];

      // temportary solution, Since we can't get the current location
      CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[@"31.236329" floatValue] longitude:[@"121.484939" floatValue]];
      
      
      
      NSMutableArray *myItems = [[NSMutableArray alloc] init];
      
      
      for (int i = 0; i < customers.count; i++) {
        NSDictionary *theObject = [customers objectAtIndex:i];
//        NSLog(@"%@", theObject);
        
        // get distance, tons of thanks to "<null>" on latitute and longitude!
        double distanceMeters;
        NSString * distanceStr;
        
//        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//        f.numberStyle = NSNumberFormatterDecimalStyle;
//        bool valid_latitude = [f numberFromString:theObject[@"latitude"]] != nil;
//        bool valid_longitude = [f numberFromString:theObject[@"longitude"]] != nil;
        NSLog(@"%@", theObject[@"latitude"]);
        
        
        
//        if ([theObject[@"latitude"] isEqualToString:@"<null>"] ||
//            [theObject[@"longitude"] isEqualToString:@"<null>"]) {
        if (theObject[@"latitude"] == nil || [theObject[@"latitude"] isEqual:[NSNull null]]) {
          distanceStr = @"9999";
        } else {
          CLLocation *Location = [[CLLocation alloc] initWithLatitude:[theObject[@"latitude"] floatValue] longitude:[theObject[@"longitude"] floatValue]];
          distanceMeters = [currentLocation distanceFromLocation:Location];
          if (_unitIsMile == 0) {
            distanceStr = [NSString stringWithFormat:@"%.2f km", distanceMeters / 1000];
          }
          else {
            distanceStr = [NSString stringWithFormat:@"%.2f mi", distanceMeters / 1600];
          }
        }
        
        NSDictionary *theCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     theObject[@"customerName"], @"name",
                                     theObject[@"address"], @"address",
                                     theObject[@"state"], @"state",
                                     theObject[@"latitude"], @"latitude",
                                     theObject[@"longitude"], @"longitude",
                                     distanceStr, @"distance", nil];
        
        NSLog(@"%@", theCustomer);
        [myItems addObject:theCustomer];
      }
      
      // Sort By different categories
      NSString * sortByStr;
      if ([[userInfo objectForKey:@"sortType"] isEqual:@"byName"]) {
        sortByStr = @"name";
      } else if ([[userInfo objectForKey:@"sortType"] isEqual:@"byState"]) {
        sortByStr = @"State";
      } else if ([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyFour"]) {
        sortByStr = @"distance";
      } else if ([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyAll"]) {
        sortByStr = @"distance";
      } else {
        NSLog(@"Doesn't recognize sort type.");
        assert(0);
      }
      
      // Sort this array with compare, Shiny Blocks!!!!
      NSArray *sortedArray;
      sortedArray = [myItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        if ([sortByStr isEqual:@"distance"]) {
          float first =  [[(NSDictionary*)a valueForKeyPath:sortByStr] floatValue];
          float second = [[(NSDictionary*)b valueForKeyPath:sortByStr] floatValue];
          return (first > second);
        }
        else {
          NSString *first = [(NSDictionary*)a valueForKeyPath:sortByStr];
          NSString *second = [(NSDictionary*)b valueForKeyPath:sortByStr];
          return [first compare:second];
        }
      }];
      
      // Insert sorted Object into tempDictionary
      int sortCount;
      if ([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyFour"]) {
        if ((int)[sortedArray count] > 4) {
          sortCount = 4;
        }
        else {
          sortCount = (int)[sortedArray count];
        }
        for (int i = 0; i < sortCount; i++) {
          id myArrayElement = [sortedArray objectAtIndex:i];
          [tempDictionary setObject:myArrayElement forKey:[@(i) stringValue]];
        }
      }
      else if([[userInfo objectForKey:@"sortType"] isEqual:@"nearbyAll"]) {
        sortCount = (int)[sortedArray count];
        for (int i = 0; i < sortCount; i++) {
          id myArrayElement = [sortedArray objectAtIndex:i];
          [tempDictionary setObject:myArrayElement forKey:[@(i) stringValue]];
        }
      }
      else {
        sortCount = (int)[sortedArray count];
        
        for (int i = 0; i < sortCount; i++) {
          id myArrayElement = [sortedArray objectAtIndex:i];
          
          NSString * firstLetter; // All swtiched to upper case
          if ([[userInfo objectForKey:@"sortType"] isEqual:@"byName"]) {
            // If starts with letter.
            if ([[NSCharacterSet letterCharacterSet] characterIsMember:[[(NSDictionary*)myArrayElement valueForKeyPath:@"name"] characterAtIndex:0]]) {
              firstLetter = [[[(NSDictionary*)myArrayElement valueForKeyPath:@"name"] substringToIndex:1] uppercaseString];
            } else {
              firstLetter = @"#";
            }
            
          } else {
            firstLetter = [[myArrayElement valueForKeyPath:@"state"] uppercaseString];
          }
          
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
      
    } else {
      // Log details of the failure
      NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    replyInfo = [NSDictionary dictionaryWithDictionary:tempDictionary];
    
  }] resume];
    
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
