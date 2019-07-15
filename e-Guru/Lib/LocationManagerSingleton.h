//
//  LocationManagerSingleton.h
//  e-Guru
//
//  Created by MI iMac01 on 28/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@protocol  LocationManagerSingletonDelegate<NSObject>
@optional
- (void)locationManagerSingletonDidUpdateLocation:(CLLocation *)location;
- (void)locationManagerFailedToUpdateLocation:(NSError *)error;
- (void)passAddressFromLocation:(EGAddress *)address;
@end

@interface LocationManagerSingleton : NSObject<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id <LocationManagerSingletonDelegate> delegate;
@property (assign, nonatomic) BOOL didFindLocation;

+(LocationManagerSingleton *)sharedLocationInstance;

-(void)getAddressFromLocation:(CLLocation *)location;
@end
