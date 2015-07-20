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
    
    // Kick off a heavy network request :)
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
}

@end
