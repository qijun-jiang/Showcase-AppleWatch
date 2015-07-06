//
//  AppDelegate.m
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/2/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

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
  
  NSDictionary * replyInfo;
  
//  reply(replyInfo);
  
  
   __block NSString *tempstr;
  
  if ([[userInfo objectForKey:@"action"]  isEqual: @"getCustomerList"]) {
    
//    reply(replyInfo);
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"star_loc"];
//    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    
//    __block int i = 0;
    
//    reply(replyInfo);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
//      reply(replyInfo);
      
      if (!error) {
        tempstr = @"success!";
        // The find succeeded.
        //NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
        
        // Do something with the found objects
        
//        reply(replyInfo);
        
        for (PFObject *object in objects) {
//          NSLog(@"%@", object.objectId);
          
//          NSString *tempstr = object.objectId;
          tempstr = object.objectId;
          
//          reply(replyInfo);
          
          [tempDictionary setObject:object forKey:tempstr];
          
//          i++;
          
          
//          reply(replyInfo);
        }
        
      } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
      }
    }];
    
    
//    replyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"Tom", @"2", @"John", @"3", @"Jim", nil];
    
//    replyInfo = [NSMutableDictionary dictionaryWithDictionary:tempDictionary];

    //replyInfo = [NSDictionary dictionaryWithDictionary:tempDictionary];
   // NSInteger *Addcount = 3;
//    tempstr = @"success!";
    replyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Aaa", tempstr, nil];
    
    
    reply(replyInfo);

  }
  
  reply(replyInfo);
}

@end
