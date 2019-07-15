//
//  ReachabilityManager.h
//  e-guru
//
//  Created by Ganesh Patro on 25/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReachabilityManager : NSObject

+ (id) sharedInstance;
- (void)startWatchingNetworkChange;
- (BOOL) isInternetAvailable;
@end
