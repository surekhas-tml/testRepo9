//
//  EGRestKitSetupManager.h
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilityMethods.h"
#import "WebServiceConstants.h"
#import <RestKit/RestKit.h>
#import "AppDelegate.h"

@interface EGRestKitSetupManager : NSObject
+(EGRestKitSetupManager *)sharedSetup;

@end
