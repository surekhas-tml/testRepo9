//
//  EGFinancierOpportunity.m
//  e-guru
//
//  Created by Admin on 03/10/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "EGFinancierOpportunity.h"

@implementation EGFinancierOpportunity

@synthesize optyID;
@synthesize isQuoteSubmittedToFinancier;
@synthesize isQuoteSubmittedToCrm;
@synthesize isAnyCaseApproved;
@synthesize is_eligible_for_insert_quote;
@synthesize is_first_case_rejected;

@synthesize toFinancierContact;
@synthesize toFinancierOpty;
@synthesize toFinancierSelectedFinancier;
@synthesize toFinancierAccount;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.optyID = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAFinancierOpportunityMO *)object{
    
    self = [super init];
        if (self) {
            self.optyID = object.optyID ? : @"";
            self.isQuoteSubmittedToCrm = object.isQuoteSubmitToCRm;
            self.isQuoteSubmittedToFinancier = object.isQuoteSubmitToFinancier;
            self.isAnyCaseApproved           = object.isAnyCaseApproved;
           
            if (object.toFinancierContact) {
                self.toFinancierContact = [[FinancierContactDetails alloc] initWithObject:object.toFinancierContact];
            }
            if (object.toFinancierOpty) {
                self.toFinancierOpty = [[FinancierOptyDetails alloc] initWithObject:object.toFinancierOpty];
            }
            if (object.toFinancierAccount) {
                self.toFinancierAccount = [[FinancierAccountDetails alloc] initWithObject:object.toFinancierAccount];
            }
            if (object.toFinancierSelectedFinancier) {
                self.toFinancierAccount = [[FinancierAccountDetails alloc] initWithObject:object.toFinancierAccount];
            }
        
        }
    return self;
    
}

@end
