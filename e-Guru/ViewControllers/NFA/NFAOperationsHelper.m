//
//  NFAOperationsHelper.m
//  e-guru
//
//  Created by Juili on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAOperationsHelper.h"

@implementation NFAOperationsHelper
-(NSMutableArray *)setActionsArrayForNFAWithStatus:(NSString *)nfaStatus andOpportunitySaleStage:(NSString *)opportunityStage{
    NSMutableArray *actionArray = [NSMutableArray array];
    if (([nfaStatus containsString:NFASTATUSPending])||([nfaStatus containsString:NFASTATUSRejected])) {
        if (![opportunityStage containsString:C0] && ![opportunityStage containsString:LOST]) {
            [actionArray addObject:UPDATE];
        }
    }
    return actionArray;
}
- (void)searchNFAForFilter:(EGSearchNFAFilter *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size fromVC:(__weak UIViewController *)senderVC{
        self.senderVC = senderVC;
        NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:[filter queryParamDict]];
        
        NSString * offsetStr = [NSString stringWithFormat:@"%lu",(unsigned long)offset];
        //TODO: remove hadrcode
        if (![[queryDict allKeys]containsObject:@"offset"]) {
            [queryDict addEntriesFromDictionary:@{@"offset":offsetStr}];
        }else{
            [queryDict setObject:offsetStr forKey:@"offset"];
        }
        
        NSString * sizeStr = [NSString stringWithFormat:@"%lu",(unsigned long)size];
        if (![[queryDict allKeys]containsObject:@"size"]) {
            [queryDict addEntriesFromDictionary:@{@"size":sizeStr}];
        }else{
            [queryDict setObject:sizeStr forKey:@"size"];
        }
    [self.senderVC performSelector:@selector(searchNFAWithQueryParameters:) withObject:queryDict afterDelay:0];
        }

-(void)UpdateNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC{
    self.senderVC = senderVC;

}
-(void)copyNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC{
    self.senderVC = senderVC;


}
-(void)cancelNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC{
    self.senderVC = senderVC;


}
@end
