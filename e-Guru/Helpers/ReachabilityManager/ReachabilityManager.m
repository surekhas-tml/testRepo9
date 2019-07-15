//
//  ReachabilityManager.m
//  e-guru
//
//  Created by Ganesh Patro on 25/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ReachabilityManager.h"
#import "AFNetworkReachabilityManager.h"
#import "Constant.h"
#import "UtilityMethods.h"

@implementation ReachabilityManager

static  ReachabilityManager *sharedInstance;

+ (id) sharedInstance {
	if (sharedInstance == nil) {
		sharedInstance = [[super alloc] init];
	}
	return sharedInstance;
}

- (void)startWatchingNetworkChange {
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];
	[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
		switch (status) {
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				// -- Reachable -- //
				NSLog(@" -- Reachable -- ");
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NETWORK_AVAILABLE object:nil];
				break;
			case AFNetworkReachabilityStatusNotReachable:
			default:
			{
				// -- Not reachable -- //
				NSLog(@" -- Not Reachable -- ");
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NETWORK_NOT_AVAILABLE object:nil];
				/*
				[UtilityMethods showAlertMessageOnWindowWithMessage:MSG_INTERNET_NOT_AVAILBLE handler:^(UIAlertAction * _Nullable action) {
				}]; */
				
				[UtilityMethods showToastWithMessage:MSG_INTERNET_NOT_AVAILBLE];
			}
				break;
		}
		
	}];
}

//TODO - to check if host is reachable instead
- (BOOL) isInternetAvailable {
	return [[AFNetworkReachabilityManager sharedManager] isReachable];
}


@end
