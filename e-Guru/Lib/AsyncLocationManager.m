//
//  AsyncLocationManager.m
//  e-guru
//
//  Created by Admin on 10/07/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "AsyncLocationManager.h"
#import "LocationManagerSingleton.h"
#import "AppRepo.h"
#import "AAAUserDataMO+CoreDataClass.h"
#import "AAAUserDataMO+CoreDataProperties.h"

@interface AsyncLocationManager() <LocationManagerSingletonDelegate> {
    NSTimer *locationUpdateTimeoutTimer;
    NSTimer *recurringLocationCaptureTimer;
    NSString *mLatitude;
    NSString *mLongitude;
}

@end

@implementation AsyncLocationManager

+ (id)sharedInstance {
    
    static AsyncLocationManager *asynLocationManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        asynLocationManagerInstance = [[AsyncLocationManager alloc] init];
    });
    return asynLocationManagerInstance;
}

- (id)init {
    if (self = [super init]) {
        mLatitude = @"0.0";
        mLongitude = @"0.0";
    }
    return self;
}

- (void)startRequestingLocation {
    
    if ([UtilityMethods isLocationCaptureEnabled]) {
        
        NSLog(@"AsyncLocationManager: Location Request Started");
        
        [[LocationManagerSingleton sharedLocationInstance] setDelegate:self];
        [[LocationManagerSingleton sharedLocationInstance] setDidFindLocation:false];
        
        [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] requestLocation];
        
        [self startLocationTimeoutTimer];
        
    } else {
        [UtilityMethods showLocationAccessDeniedAlert];
    }

}

- (void)stopRequestingLocation {
    NSLog(@"AsyncLocationManager: Location Request Stopped");
    
    [self stopLocationTimeoutTimer];
    
    [[[LocationManagerSingleton sharedLocationInstance] myLocationManager] stopUpdatingLocation];
    
}

- (void)startAsyncLocationFetch {
    NSLog(@"AsyncLocationManager: startAsyncLocationFetch");
    
    [self stopRecurringLocationCaptureTimer];
    [self stopLocationTimeoutTimer];
    
    [self startRequestingLocation];
    
    [self startRecurringLocationCaptureTimer];
}

- (void)stopAsyncLocationFetch {
    NSLog(@"AsyncLocationManager: stopAsyncLocationFetch");
    
    [self stopRecurringLocationCaptureTimer];
    
    [self stopRequestingLocation];
}

- (void)startLocationTimeoutTimer {
    
    if (!locationUpdateTimeoutTimer) {
        locationUpdateTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_FETCH_TIMEOUT target:self selector:@selector(stopRequestingLocation) userInfo:nil repeats:false];
    }
}

- (void)stopLocationTimeoutTimer {
    
    if (locationUpdateTimeoutTimer && locationUpdateTimeoutTimer.isValid) {
        [locationUpdateTimeoutTimer invalidate];
    }
    
    locationUpdateTimeoutTimer = nil;
}

- (void)startRecurringLocationCaptureTimer {
    
    if (!recurringLocationCaptureTimer) {
        recurringLocationCaptureTimer = [NSTimer scheduledTimerWithTimeInterval:RECURRING_LOCATION_CAPTURE_INTERVAL target:self selector:@selector(startRequestingLocation) userInfo:nil repeats:true];
    }
}

- (void)stopRecurringLocationCaptureTimer {
    
    if (recurringLocationCaptureTimer && recurringLocationCaptureTimer.isValid) {
        [recurringLocationCaptureTimer invalidate];
    }
    
    recurringLocationCaptureTimer = nil;
}

- (void)locationManagerSingletonDidUpdateLocation:(CLLocation *)location {
    NSLog(@"AsyncLocationManager: location received %@", location);
    
    [self stopRequestingLocation];
    mLatitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    mLongitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    [self saveLatitude:mLatitude andLongitude:mLongitude];
}

- (void)locationManagerFailedToUpdateLocation:(NSError *)error {
    NSLog(@"AsyncLocationManager: location receive failed");
    
    [self stopRequestingLocation];
}

- (void)saveLatitude:(NSString *)latitude andLongitude:(NSString *)longitude {
    
    AAAUserDataMO *loggedInUser = [[AppRepo sharedRepo] getLoggedInUser];
    loggedInUser.latitude = latitude;
    loggedInUser.longitude = longitude;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    [appDelegate.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end
