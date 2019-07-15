//
//  NFAUIHelper.m
//  e-guru
//
//  Created by MI iMac04 on 02/03/17.
//  Copyright © 2017 TATA. All rights reserved.
//

#import "NFAUIHelper.h"
#import "DealerAndCustomerDetailsView.h"
#import "DealDetailsView.h"
#import "CompetitionDetailsView.h"
#import "TMLProposedLandingPriceView.h"
#import "DealerMarginAndRetentionView.h"
#import "SchemeDetailsView.h"
#import "FinancierDetailsView.h"
#import "NFARequestView.h"

@implementation NFAUIHelper

+ (NSMutableArray *)getNFASectionsWithData:(EGNFA *)nfaModel
                         forNFARequestType:(NFARequestType)requestType
                                   forMode:(NFAMode)nfaMode {
    
    NSMutableArray *sectionList;
    
    switch (requestType) {
        case NFATypeAdditonalSupport:
            sectionList = [self getNFASectionsForAdditionalSupportWithData:nfaModel forMode:nfaMode];
            break;
        case NFATypeActivitySpend:
            sectionList = [self getNFASectionsForActivitySpend];
            break;
        case NFATypeOtherSupport:
            sectionList = [self getNFASectionsForOtherSupport];
            break;
            
        default:
            sectionList = [self getNFASectionsForAdditionalSupportWithData:nfaModel forMode:nfaMode];
            break;
    }
    
    return sectionList;
}

+ (NSMutableArray *)getNFASectionsForAdditionalSupportWithData:(EGNFA *)nfaModel
                                                       forMode:(NFAMode)nfaMode{
    
    NSMutableArray *sectionList = [[NSMutableArray alloc] init];
    
    DealerAndCustomerDetailsView *dealerAndCustomerDetailsView = [[DealerAndCustomerDetailsView alloc] initWithMode:nfaMode andModel:nfaModel? : nil];
    DealDetailsView *dealDetailsView = [[DealDetailsView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaDealDetails: nil];
    CompetitionDetailsView *competitionDetailsView = [[CompetitionDetailsView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaCompetitionDetails: nil];
    TMLProposedLandingPriceView *tmlProposedLandingPriceView = [[TMLProposedLandingPriceView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaTMLProposedLandingPrice: nil];
    DealerMarginAndRetentionView *dealerMarginAndRetentionView = [[DealerMarginAndRetentionView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaDealerMarginAndRetention: nil];
    SchemeDetailsView *schemeDetailsView = [[SchemeDetailsView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaSchemeDetails: nil];
    FinancierDetailsView *financierDetailsView = [[FinancierDetailsView alloc] initWithMode:nfaMode andModel:nfaModel?nfaModel.nfaFinancierDetails: nil];
    NFARequestView *nfaRequestView = [[NFARequestView alloc] initWithMode:nfaMode andModel:nfaModel? : nil];
    
    [sectionList addObject:dealerAndCustomerDetailsView];
    [sectionList addObject:dealDetailsView];
    [sectionList addObject:competitionDetailsView];
    [sectionList addObject:tmlProposedLandingPriceView];
    [sectionList addObject:dealerMarginAndRetentionView];
    [sectionList addObject:schemeDetailsView];
    [sectionList addObject:financierDetailsView];
    [sectionList addObject:nfaRequestView];
    
    return sectionList;
}

+ (NSMutableArray *)getNFASectionsForActivitySpend {
    NSMutableArray *sectionList = [[NSMutableArray alloc] init];
    
    return sectionList;
}

+ (NSMutableArray *)getNFASectionsForOtherSupport {
    NSMutableArray *sectionList = [[NSMutableArray alloc] init];
    
    return sectionList;
}

@end
