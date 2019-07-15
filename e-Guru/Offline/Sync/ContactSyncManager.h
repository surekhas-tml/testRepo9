//
//  ContactSyncManager.h
//  e-guru
//
//  Created by MI iMac04 on 04/09/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactSyncManager : NSObject

+(ContactSyncManager *) sharedSyncManager;

-(void) start;

@end
