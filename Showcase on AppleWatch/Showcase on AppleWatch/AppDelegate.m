//
//  AppDelegate.m
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/2/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@import CoreLocation;

@interface AppDelegate ()
@property MKMapView *mapView;
@property NSInteger unitIsMile;
@property NSInteger showInTime;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // [Optional] Power your app with Local Datastore. For more info, go to
  // https://parse.com/docs/ios_guide#localdatastore/iOS
  [Parse enableLocalDatastore];
  
  // Initialize Parse.
  [Parse setApplicationId:@"wghZveBiDWjSkMccFel3OoYD7qWzGN7Fer3UDcJ0"
                clientKey:@"RMUu1Mknlxl0HVT1iLHyJQ1uH6yq2z5x3PrmQ2gL"];
  
  // [Optional] Track statistics around application opens.
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  // ...
  return YES;
}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//  
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *replyInfo))reply {

  if ([userInfo objectForKey:@"setUnitIsMile"] != nil) {
    _unitIsMile = [[userInfo objectForKey:@"setUnitIsMile"] intValue];
    NSDictionary *replyInfo = nil;
    //NSDictionary *replyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                                         [NSString stringWithFormat:@"aaaaa=%ld",_unitIsMile], @"unit", nil];
    reply(replyInfo);
  }
  
  /*
   * For NearbyListController
   */
  if ([[userInfo objectForKey:@"getCustomers"] isEqual: @"customerList"]) {
    
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
        
              CLLocationManager *lm = [[CLLocationManager alloc] init];
        //      lm.delegate = self;
              lm.desiredAccuracy = kCLLocationAccuracyBest;
              lm.distanceFilter = kCLHeadingFilterNone;
              [lm requestWhenInUseAuthorization];
              [lm startUpdatingLocation];
              CLLocation *currentLocation = [lm location];
        
        // temportary solution, Since we can't get the current location on simulator
        //CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[@"31.236329" floatValue] longitude:[@"121.484939" floatValue]];
        
        
        
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
            if (_unitIsMile == 0) {
              distanceStr = @"9999 km";
            } else {
              distanceStr = @"9999 mi";
            }
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
          
          NSMutableString* customerName;
          NSMutableString* address;
          NSMutableString* state;
          NSMutableString* latitude;
          NSMutableString* longitude;
          if (theObject[@"customerName"] == nil || [theObject[@"customerName"] isEqual:[NSNull null]]){
            customerName = [NSMutableString stringWithString: @"unknown"];
          } else {
            if ([theObject[@"customerName"] isEqualToString:@""]) {
              customerName = [NSMutableString stringWithString: @"unknown"];
            } else {
              customerName = [NSMutableString stringWithString: theObject[@"customerName"]];
            }
          }
          if (theObject[@"address"] == nil || [theObject[@"address"] isEqual:[NSNull null]]){
            address = [NSMutableString stringWithString: @"unknown"];
          } else {
            if ([theObject[@"address"] isEqualToString:@""]) {
              address = [NSMutableString stringWithString: @"unknown"];
            } else {
              address = [NSMutableString stringWithString: theObject[@"address"]];
            }
          }
          if (theObject[@"state"] == nil || [theObject[@"state"] isEqual:[NSNull null]]){
            state = [NSMutableString stringWithString: @"unknown"];
          } else {
            if ([theObject[@"state"] isEqualToString:@""]) {
              state = [NSMutableString stringWithString: @"unknown"];
            } else {
              state = [NSMutableString stringWithString: theObject[@"state"]];
            }
          }
          
          if (theObject[@"latitude"] == nil || [theObject[@"latitude"] isEqual:[NSNull null]]){
            latitude = [NSMutableString stringWithString: @"0"];
          } else {
            latitude = [NSMutableString stringWithString: theObject[@"latitude"]];
          }
          if (theObject[@"longitude"] == nil || [theObject[@"longitude"] isEqual:[NSNull null]]){
            longitude = [NSMutableString stringWithString: @"0"];
          } else {
            longitude = [NSMutableString stringWithString: theObject[@"longitude"]];
          }
          
          NSDictionary *theCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       customerName, @"name",
                                       address, @"address",
                                       state, @"state",
                                       latitude, @"latitude",
                                       longitude, @"longitude",
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
      reply(replyInfo);
    }] resume];
    
    //---------------------URL Request end-------------------//
    
    
    //--------------------Parse Request-------------------------//
    
    if(false) {
    
    PFQuery *query = [PFQuery queryWithClassName:@"location"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
      NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
      NSDictionary * replyInfo;
      
      
      if (!error) {
              CLLocationManager *lm = [[CLLocationManager alloc] init];
              lm.delegate = self;
              lm.desiredAccuracy = kCLLocationAccuracyBest;
              lm.distanceFilter = kCLHeadingFilterNone;
              [lm requestWhenInUseAuthorization];
              [lm startUpdatingLocation];
              //CLLocation *currentLocation = [lm location];
        
        // temportary solution, Since we can't get the current location
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:[@"31.236329" floatValue] longitude:[@"121.584939" floatValue]];
        
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
          
          // ----------------- BEGIN: To be coded ------------------ //
          
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
          
          // ----------------- END: To be coded ------------------ //
        }
        
      } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
      
      replyInfo = [NSDictionary dictionaryWithDictionary:tempDictionary];
      reply(replyInfo);
    }];
      
    }
    // -------------------Parse Request Ends----------------------------//
  }
}

@end
