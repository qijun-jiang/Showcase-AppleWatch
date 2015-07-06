//
//  MapViewController.h
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/13/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
//{
  //  MKMapView *mapview;
//}

//@property (strong,nonatomic) IBOutlet MKMapView *mapview;

@property (strong, nonatomic) IBOutlet MKMapView *mymapview;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet NSString *annTitle;
@property (strong, nonatomic) IBOutlet NSString *annSub;
@property (strong, nonatomic) IBOutlet MKRoute *walkingRoute;

- (IBAction)setMap:(id)sender;

@end
