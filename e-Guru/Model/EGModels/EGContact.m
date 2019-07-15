//
//  EGContact.m
//  e-Guru
//
//  Created by Juili on 27/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "EGContact.h"

@implementation EGContact
@synthesize primaryAccountId;
@synthesize area;

@synthesize contactID;
@synthesize contactNumber;
@synthesize emailID;
@synthesize firstName;
@synthesize lastName;
@synthesize panNumber;
@synthesize fullName;
@synthesize toAccount;
@synthesize toAddress;
@synthesize toOpportunity;
@synthesize primary_account_id;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.primaryAccountId = @"";
        self.area = @"";
        self.contactID = @"";
        self.contactNumber = @"";
        self.emailID = @"";
        self.firstName = @"";
        self.lastName = @"";
        self.panNumber = @"";
        self.fullName = @"";
        self.primary_account_id = @"";
        self.latitude = @"";
        self.longitude = @"";
    }
    return self;
}

-(instancetype)initWithObject:(AAAContactMO *)object{
    self = [super init];
    if (self) {
        self.contactID = object.contactID? : @"";
        self.contactNumber = object.contactNumber? : @"";
        self.emailID = object.emailID? : @"";
        self.firstName = object.firstName? : @"";
        self.lastName = object.lastName? : @"";
        self.panNumber = object.panNumber? : @"";
        self.fullName = object.fullName? : @"";
        self.latitude = object.latitude? : @"";
        self.longitude = object.longitude? : @"";
        self.toAccount = [NSSet setWithObject:[[EGAccount alloc]initWithObject:[[object.toAccount allObjects] firstObject]]];
        self.toAddress = [[EGAddress alloc]initWithObject:object.toAddress];
        self.primary_account_id = object.primary_account_id? : @"";
    }
    return self;
}

//- (EGContact *)parseFromDictioanry:(NSDictionary *)dictContact {
//	EGContact *egContact = [EGContact new];
//	egContact.firstName = dictContact[@"first_name"];
//	egContact.lastName = dictContact[@"last_name"];
//	egContact.contactNumber = dictContact[@"mobile_number"];
//	egContact.panNumber = dictContact[@"pan"];
//	
//	NSDictionary *addressDictionary = dictPayload[@"address"];
//	
//	
//	egContact.firstName = dictPayload[@"address"][@""];
//}



@end
