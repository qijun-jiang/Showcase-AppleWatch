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

  
  /*
   * For NearbyListController
   */
  
  if ([[userInfo objectForKey:@"getCustomers"] isEqual: @"NearbyList"]) {
    
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
//        NSString *sortByStr = @"distance";
//        NSString *sortByStr = @"name";
        NSString *sortByStr = @"State";
        
        // Sort this array with compare, Shiny Blocks!!!!
        NSArray *sortedArray;
        sortedArray = [myItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
          NSString *first = [(NSDictionary*)a valueForKeyPath:sortByStr];
          NSString *second = [(NSDictionary*)b valueForKeyPath:sortByStr];
          return [first compare:second];
        }];
        
        // Insert sorted Object into tempDictionary
        for (int i = 0; i < [sortedArray count]; i++) {
          id myArrayElement = [sortedArray objectAtIndex:i];
          [tempDictionary setObject:myArrayElement forKey:[@(i) stringValue]];
        }
        
      } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
      
      replyInfo = [NSDictionary dictionaryWithDictionary:tempDictionary];
      reply(replyInfo);
    }];
  }
  
  
  /*
   * For NearbyMapController
   */
  if ([[userInfo objectForKey:@"getCustomers"] isEqual: @"NearbyMap"]) {
    
    PFQuery *query = [PFQuery queryWithClassName:@"location"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
      NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
      NSDictionary * replyInfo;
      
      if (!error) {
        NSDictionary *theCustomer;
        
        for (PFObject *object in objects) {
          NSString *tempstr1 = object.objectId;
          theCustomer = [[NSDictionary alloc] initWithObjectsAndKeys:
                         object[@"Name"], @"name",
                         object[@"Latitude"], @"latitude",
                         object[@"Longitud"], @"longitude",nil];
          
          [tempDictionary setObject:theCustomer forKey:tempstr1];
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
