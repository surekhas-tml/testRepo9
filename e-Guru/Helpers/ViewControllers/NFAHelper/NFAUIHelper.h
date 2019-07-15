//
//  NFAUIHelper.h
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGNFA.h"
#import "NFAUIHelper.h"

typedef enum {
    NFATypeAdditonalSupport,
    NFATypeActivitySpend,
    NFATypeOtherSupport
}NFARequestType;

typedef enum {
    NFASectionDealerAndCustomerDetails,
    NFASectionDealDetails,
    NFASectionCompetitionDetails,
    NFASectionTMLProposedLandingPrice,
    NFASectionDealerMarginAndRetention,
    NFASectionSchemeDetails,
    NFASectionFinancierDetails,
    NFASectionNFARequest
}NFASectionType;

typedef enum {
    FinancierPersonalDetailsVw,
    FinancierContactsDetailsVw,
    FinancierAccountDetailsVw,
    FinancierVehicleDetailsVw,
    RetailFinancierDetailsVw,
    } FinancierSectionType;

typedef enum {
    FinancierModeCreate,
    FinancierModeDisplay
}FinancierMode;

typedef enum {
    NFAModeCreate,
    NFAModeUpdate,
    NFAModeDisplay
}NFAMode;

@interface NFAUIHelper : NSObject

+ (NSMutableArray *)getNFASectionsWithData:(EGNFA *)nfaModel
                         forNFARequestType:(NFARequestType)requestType
                                   forMode:(NFAMode)nfaMode;

@end
