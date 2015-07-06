//
//  MapViewController.m
//  Showcase on AppleWatch
//
//  Created by Cheng Hua on 6/13/15.
//  Copyright (c) 2015 Cheng Hua. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mymapview=_mapview;
@synthesize annTitle=_annTitle;
@synthesize annSub=_annSub;
@synthesize walkingRoute=_walkingRoute;
MKRoute *route;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mymapview.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(1) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }    
    
    [self.mymapview setShowsUserLocation:YES];
    
    
    //Annotation
    NSMutableArray *locations=[[NSMutableArray alloc] init];
    NSMutableArray *lat = [[NSMutableArray alloc]initWithObjects:@"37.7867266", @"37.0703517", @"37.1610806", @"37.318367", @"37.3559204", @"37.4154066", @"37.4757622", @"37.7450252", @"37.6318978", @"37.0716803", nil];
    
    NSMutableArray *lon = [[NSMutableArray alloc]initWithObjects:@"-87.608209", @"-88.1237899", @"-87.9148629", @"-87.5074402", @"-87.5448032", @"-87.8003148", @"-87.9515986", @"-87.9061638", @"-87.1148574", @"-87.3008418", nil];
    
    NSMutableArray *title1 = [[NSMutableArray alloc]initWithObjects:@"Cates Farm", @"Broadbent B & B Foods", @"Cayce's Pumpkin Patch", @"Metcalfe Landscaping", @"Brumfield Farm Market", @"Dogwood Valley Farm", @"Country Fresh Meats & Farmers Market", @"Jim David Meats", @"Trunnell's Farm Market", @"Lovell's Orchard & Farm Market", nil];
    
    NSMutableArray *subtitle1 = [[NSMutableArray alloc]initWithObjects:@"Hwy 425 Henderson, KY 42420", @"257 Mary Blue Road Kuttawa, KY 42055", @"153 Farmersville Road Princeton, KY 42445", @"410 Princeton Road Madisonville, KY 42431", @"3320 Nebo Road Madisonville, KY 42431", @"4551 State Route 109N Clay, KY 42404", @"9355 US Hwy 60 W Sturgis, KY 42459",@"350 T. Frank Wathen Rd. Uniontown, KY 42461", @"9255 Hwy 431 Utica, KY 42376", @"22850 Coal Creek Road Hopkinsville, KY 42240", nil];
    
    CLLocationCoordinate2D Location;
    MKPointAnnotation * point;
    
    
    for (int x = 0; x < [lat count]; x++) {
        point= [[MKPointAnnotation alloc] init];
        Location.latitude=[[lat objectAtIndex:x]floatValue];
        Location.longitude=[[lon objectAtIndex:x]floatValue];
        point.coordinate = Location;
        point.title = [title1 objectAtIndex:x];
        point.subtitle = [subtitle1 objectAtIndex:x];
        [locations addObject:point];
    }
    [self.mymapview addAnnotations:locations];
    
    //YAYAYAYAY
    /*
    CLLocationCoordinate2D Location1;
    Location.latitude=[[lat objectAtIndex:0]floatValue];
    Location.longitude=[[lon objectAtIndex:0]floatValue];
    Location1.latitude=[[lat objectAtIndex:1]floatValue];
    Location1.longitude=[[lon objectAtIndex:1]floatValue];
    
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:Location1
                              addressDictionary:nil];;
    
    MKPlacemark *placemark1 = [[MKPlacemark alloc]
                              initWithCoordinate:Location
                              addressDictionary:nil];;
    
    //[directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setSource:[[MKMapItem alloc] initWithPlacemark:placemark1]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            route = response.routes.lastObject;
            [self.mymapview addOverlay:route.polyline];
        }
    }];*/
    }

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route.polyline];
    routeLineRenderer.strokeColor = [UIColor redColor];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
}

//
 - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self.mymapview removeOverlay:route.polyline];
    MKPointAnnotation *ann = [[self.mymapview selectedAnnotations] objectAtIndex:0];
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:ann.coordinate
                              addressDictionary:nil];;
    
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            route = response.routes.lastObject;
            [self.mymapview addOverlay:route.polyline];
        }
    }];

    /*
    MKPointAnnotation *ann = [[mapView selectedAnnotations] objectAtIndex:0];    CLLocationCoordinate2D start = _mapview.userLocation.location.coordinate;
    CLLocationCoordinate2D destination = [ann coordinate];
    
    NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",
                                     start.latitude, start.longitude, destination.latitude, destination.longitude];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
     */
    
    
  /*
    MKPointAnnotation *ann = [[self.mymapview selectedAnnotations] objectAtIndex:0];
    MKDirectionsRequest *walkingRouteRequest = [[MKDirectionsRequest alloc] init];
    walkingRouteRequest.transportType = MKDirectionsTransportTypeWalking;
    [walkingRouteRequest setSource: [MKMapItem mapItemForCurrentLocation]];
    
    MKPlacemark *mkDest = [[MKPlacemark alloc]
                           initWithCoordinate:ann.coordinate
                           addressDictionary:nil];
    [walkingRouteRequest setDestination:[[MKMapItem alloc] initWithPlacemark:mkDest]];
    //[walkingRouteRequest setDestination:[MKMapItem mapItemForCurrentLocation]];
    MKDirections *walkingRouteDirections = [[MKDirections alloc] initWithRequest:walkingRouteRequest];
    [walkingRouteDirections calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * walkingRouteResponse, NSError *walkingRouteError) {
        if (!walkingRouteError) {
            // The code doesn't request alternate routes, so add the single calculated route to
            // a previously declared MKRoute property called walkingRoute.
            for (MKRoute *route in [walkingRouteResponse routes]){
                [self.mymapview addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];}
            MKRoute *route = walkingRouteResponse.routes[0];
            [self.mymapview addOverlay:route.polyline];
            
        }
    }];
*/
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //Get Coords (written)
    CLLocationCoordinate2D myLocation = [userLocation coordinate];
    
    //Zoom Region
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(myLocation, 2500000, 2500000);
    
    //Show Our Location
    [self.mymapview setRegion:zoomRegion animated:YES];
    
    
    
}
/////////////////////////////////////////////
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // If it's the user location, return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Try to dequeue an existing pin view first
    static NSString *annotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    // [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapViewController *detail = [[MapViewController alloc] initWithNibName:nil bundle:nil];
    id<MKAnnotation> ann = [mapView.selectedAnnotations objectAtIndex:0];
    ann = view.annotation;
    detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@", ann.title);
    NSLog(@"%@", ann.subtitle);
    detail.annTitle = ann.title;
    detail.annSub = ann.subtitle;
    [self.navigationController pushViewController:detail animated:YES];
    
   }






////////////////////////////////////////////
-(bool)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation !=UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)setMap:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            _mapview.mapType = MKMapTypeStandard;
            break;
        case 1:
            _mapview.mapType = MKMapTypeSatellite;
            break;
        case 2:
            _mapview.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
    
}

@end
