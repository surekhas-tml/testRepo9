//
//  NFAStatusMode.m
//  e-guru
//
//  Created by Juili on 22/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAStatusMode.h"
@implementation NFAStatusMode
@synthesize status,nfaStatusValue;
static NSDictionary *map = nil;

+(NSDictionary *)map{
    if (!map) {
        map = [NSMutableDictionary dictionary];
        [map setValue:[NSNumber numberWithInt:PendingForLOBHeadApproval] forKey:[NFAStatusMode getStringValueFor:PendingForLOBHeadApproval]];
        [map setValue:[NSNumber numberWithInt:PendingForMarketingHeadApproval] forKey:[NFAStatusMode getStringValueFor:PendingForMarketingHeadApproval]];
        [map setValue:[NSNumber numberWithInt:PendingForRMApproval] forKey:[NFAStatusMode getStringValueFor:PendingForRMApproval]];
        [map setValue:[NSNumber numberWithInt:PendingForRSMApproval] forKey:[NFAStatusMode getStringValueFor:PendingForRSMApproval]];
        [map setValue:[NSNumber numberWithInt:PendingForSPMApproval] forKey:[NFAStatusMode getStringValueFor:PendingForSPMApproval]];
        
        [map setValue:[NSNumber numberWithInt:RejectedByLOBHead] forKey:[NFAStatusMode getStringValueFor:RejectedByLOBHead]];
        [map setValue:[NSNumber numberWithInt:RejectedByRM] forKey:[NFAStatusMode getStringValueFor:RejectedByRM]];
        [map setValue:[NSNumber numberWithInt:RejectedByRSM] forKey:[NFAStatusMode getStringValueFor:RejectedByRSM]];
        [map setValue:[NSNumber numberWithInt:RejectedByMarketingHead] forKey:[NFAStatusMode getStringValueFor:RejectedByMarketingHead]];
        [map setValue:[NSNumber numberWithInt:RejectedBySPM] forKey:[NFAStatusMode getStringValueFor:RejectedBySPM]];

        [map setValue:[NSNumber numberWithInt:ApproveByLOBHead] forKey:[NFAStatusMode getStringValueFor:ApproveByLOBHead]];
        [map setValue:[NSNumber numberWithInt:ApproveByMarketingHead] forKey:[NFAStatusMode getStringValueFor:ApproveByMarketingHead]];
        [map setValue:[NSNumber numberWithInt:ApproveByRM] forKey:[NFAStatusMode getStringValueFor:ApproveByRM]];
        [map setValue:[NSNumber numberWithInt:ApproveByRSM] forKey:[NFAStatusMode getStringValueFor:ApproveByRSM]];
        [map setValue:[NSNumber numberWithInt:ApproveBySPM] forKey:[NFAStatusMode getStringValueFor:ApproveBySPM]];
        
        [map setValue:[NSNumber numberWithInt:Expired] forKey:[NFAStatusMode getStringValueFor:Expired]];
        [map setValue:[NSNumber numberWithInt:Cancelled] forKey:[NFAStatusMode getStringValueFor:Cancelled]];
        [map setValue:[NSNumber numberWithInt:SubmittedByDealer] forKey:[NFAStatusMode getStringValueFor:SubmittedByDealer]];
        [map setValue:[NSNumber numberWithInt:CancelledByDSM] forKey:[NFAStatusMode getStringValueFor:CancelledByDSM]];
        [map setValue:[NSNumber numberWithInt:CancelledByTSM] forKey:[NFAStatusMode getStringValueFor:CancelledByTSM]];
        [map setValue:[NSNumber numberWithInt:CancelledByUser] forKey:[NFAStatusMode getStringValueFor:CancelledByUser]];
        [map setValue:[NSNumber numberWithInt:CancelledAsOptyClosedLost] forKey:[NFAStatusMode getStringValueFor:CancelledAsOptyClosedLost]];
    }
    return map;
}
+ (NSMutableArray *) getLisOfEnum{
    NSMutableArray * modes = [NSMutableArray array];
    [modes addObject:[NFAStatusMode getStringValueFor:PendingForSPMApproval]];
    [modes addObject:[NFAStatusMode getStringValueFor:PendingForLOBHeadApproval]];
    [modes addObject:[NFAStatusMode getStringValueFor:PendingForMarketingHeadApproval]];
    [modes addObject:[NFAStatusMode getStringValueFor:PendingForRMApproval]];
    [modes addObject:[NFAStatusMode getStringValueFor:PendingForRSMApproval]];
    
    [modes addObject:[NFAStatusMode getStringValueFor:RejectedBySPM]];
    [modes addObject:[NFAStatusMode getStringValueFor:RejectedByLOBHead]];
    [modes addObject:[NFAStatusMode getStringValueFor:RejectedByRM]];
    [modes addObject:[NFAStatusMode getStringValueFor:RejectedByRSM]];
    [modes addObject:[NFAStatusMode getStringValueFor:RejectedByMarketingHead]];

    [modes addObject:[NFAStatusMode getStringValueFor:ApproveBySPM]];
    [modes addObject:[NFAStatusMode getStringValueFor:ApproveByLOBHead]];
    [modes addObject:[NFAStatusMode getStringValueFor:ApproveByMarketingHead]];
    [modes addObject:[NFAStatusMode getStringValueFor:ApproveByRM]];
    [modes addObject:[NFAStatusMode getStringValueFor:ApproveByRSM]];
    
    [modes addObject:[NFAStatusMode getStringValueFor:Expired]];
    [modes addObject:[NFAStatusMode getStringValueFor:CancelledByDSM]];
    [modes addObject:[NFAStatusMode getStringValueFor:CancelledByTSM]];
    [modes addObject:[NFAStatusMode getStringValueFor:CancelledByUser]];
    [modes addObject:[NFAStatusMode getStringValueFor:CancelledAsOptyClosedLost]];
    [modes addObject:[NFAStatusMode getStringValueFor:Cancelled]];
    [modes addObject:[NFAStatusMode getStringValueFor:SubmittedByDealer]];
    return modes;
}

-(int)getStatus {
    return status;
}

+(NSString *)getStringValueFor:(NFAStatusValue)status {
    NSString *stringValue = nil;
    switch (status) {
        case 1: {
            stringValue = @"Pending For SPM Approval";
        }
            break;
        case 2: {
            stringValue = @"Pending For RSM Approval";
        }
            break;
        case 4: {
            stringValue = @"Pending For RM Approval";
        }
            break;
        case 8: {
            stringValue = @"Pending For LOB Head Approval";
        }
            break;
        case 16: {
            stringValue = @"Pending For Marketing Head Approval";
        }
            break;
        case 32: {
            stringValue = @"Rejected By SPM";
        }
            break;
        case 64: {
            stringValue = @"Rejected By RSM";
        }
            break;
        case 128: {
            stringValue = @"Rejected By RM";
        }
            break;
        case 256: {
            stringValue = @"Rejected By LOB Head";
        }
            break;
        case 512: {
            stringValue = @"Rejected By Marketing Head";
        }
            break;
        case 1024: {
            stringValue = @"Approve By SPM";
        }
            break;
        case 2048: {
            stringValue = @"Approve By LOB Head";
        }
            break;
        case 4096: {
            stringValue = @"Approve By Marketing Head";
        }
            break;
        case 8192: {
            stringValue = @"Approve By RSM";
        }
            break;
        case 16384: {
            stringValue = @"Approve By RM";
        }
            break;
        case 32768: {
            stringValue = @"Cancelled By DSM";
        }
            break;
        case 65536: {
            stringValue = @"Cancelled by TSM";
        }
            break;
        case 131072: {
            stringValue = @"Cancelled by User";
        }
            break;
        case 262144: {
            stringValue = @"Cancelled as Opty Closed Lost";
        }
            break;
        case 524288: {
            stringValue = @"Cancelled";
        }
            break;
        case 1048576: {
            stringValue = @"Expired";
        }
            break;
        case 2097152: {
            stringValue = @"Submitted By Dealer";
        }
            break;
    }
    return stringValue;
}

+(int)fromString:(NSString*)stringValue{
    if ([[NFAStatusMode getLisOfEnum]containsObject:stringValue]){
        return [[map objectForKey:stringValue]intValue];
    }
    return 0;
}
+(NSString *)toString:(NFAStatusValue)modeString {
    return [NFAStatusMode getStringValueFor:modeString];
}


@end
