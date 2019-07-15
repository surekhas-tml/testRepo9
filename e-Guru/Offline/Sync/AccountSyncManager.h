//
//  AccountSyncManager.h
//  e-guru
//
//  Created by MI iMac04 on 30/08/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSyncManager : NSObject

+(AccountSyncManager *) sharedSyncManager;

-(void) start;

@end
