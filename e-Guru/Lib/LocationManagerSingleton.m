//
//  LocationManagerSingleton.m
//  e-Guru
//
//  Created by MI iMac01 on 28/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "LocationManagerSingleton.h"

@interface LocationManagerSingleton()
{
    CLGeocoder* geocoder;
    CLPlacemark* placemark;
}
@end

@implementation LocationManagerSingleton

+(LocationManagerSingleton *)sharedLocationInstance
{
    static LocationManagerSingleton *myLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myLocation = [[self alloc] init];
    });
    return myLocation;
}

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _myLocationManager = [[CLLocationManager alloc] init];
        _myLocationManager.delegate = self;
        _myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _myLocationManager.distanceFilter = 30;
        
        if ([_myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_myLocationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)locationManager: (CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    for (CLLocation *location in locations) {
        
        if (location.verticalAccuracy < 100 && location.horizontalAccuracy < 100) {
            if (!self.didFindLocation) {
                self.didFindLocation = true;
                
                [self.myLocationManager stopUpdatingLocation];
                if ([self.delegate respondsToSelector:@selector(locationManagerSingletonDidUpdateLocation:)]) {
                    [self.delegate locationManagerSingletonDidUpdateLocation:locations.lastObject];
                    
                }
                break;
            }
        }
    }
    
    [self setLocation:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(nonnull NSError *)error
{
    NSLog(@"LocationManager error is %@", error);
    if ([self.delegate respondsToSelector:@selector(locationManagerFailedToUpdateLocation:)]) {
        [self.delegate locationManagerFailedToUpdateLocation:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    NSLog(@"Authorization Status Changed:%d", status);
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
            
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
            
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"kCLAuthorizationStatusAuthorizedAlways");
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            break;
            
        default:
            break;
    }
}

-(void)getAddressFromLocation:(CLLocation *)location
{
    EGAddress * address = [[EGAddress alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error) {
        
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            address.district = placemark.addressDictionary[@"SubAdministrativeArea"];
            address.state = [EGState new];
            address.state.name = placemark.addressDictionary[@"State"];
            address.city = placemark.addressDictionary[@"City"];
            address.pin = placemark.addressDictionary[@"ZIP"];
            address.taluka.city = placemark.addressDictionary[@"City"];
            NSString *items1 = [[[[[placemark.addressDictionary[@"FormattedAddressLines"] objectAtIndex:0]stringByAppendingString:@" "]stringByAppendingString:[placemark.addressDictionary[@"FormattedAddressLines"] objectAtIndex:1]]stringByAppendingString:@" "]stringByAppendingString:@""];
            NSLog(@"-- Items :%@",items1);
            address.addressLine1 =items1;
            
            // Turn off the location manager to save power.
            [self.myLocationManager stopUpdatingLocation];
            
            if ([self.delegate respondsToSelector:@selector(passAddressFromLocation:)]) {
                [self.delegate passAddressFromLocation:address];
            }
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
    
}

@end
