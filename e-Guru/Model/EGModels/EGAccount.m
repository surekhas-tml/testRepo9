//
//  EGAccount.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGAccount.h"
#import "EGAddress.h"
#import "EGContact.h"

@implementation EGAccount
@synthesize accountID;
@synthesize accountName;
@synthesize accountType;
@synthesize contactNumber;
@synthesize siteName;
@synthesize toAddress;
@synthesize toContact;
@synthesize toOpportunity;
@synthesize mPAN;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.accountID = @"";
        self.accountName = @"";
        self.accountType = @"";
        self.contactNumber = @"";
        self.siteName = @"";
        self.mPAN = @"";
    }
    return self;
}

-(_Nonnull instancetype)initWithObject:(AAAAccountMO *)account
{
    self = [super init];
    if (self) {
        self.accountID = account.accountID? : @"";
        self.accountName = account.accountName? : @"";
        self.accountType = account.accountType? : @"";
        self.contactNumber = account.contactNumber? : @"";
        self.siteName = account.site? : @"";
        self.mPAN = account.accountPAN? : @"";
        self.toAddress = [[EGAddress alloc]initWithObject:account.toAddress];
        }
    return self;
}
@end
