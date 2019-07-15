//
//  LobDBHelper.h
//  e-guru
//
//  Created by Ganesh Patro on 24/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VCNumberDBHelper : NSObject

- (NSArray *)fetchAllLOB;
- (NSArray *)fetchAllPPLFromLob:(NSString *)strLOB;
- (NSArray *)fetchAllPLFromLob:(NSString *)strLOB withPPL:(NSString *)strPPL;
- (NSArray *)fetchAllVCNumberWithPL:(NSString *)strPL withPPL:(NSString *)ppl withLOB:(NSString *)lob;
- (NSArray *)fetchAllVCNumberWithSearchQuery:(NSString *)strSearchText;

@end
