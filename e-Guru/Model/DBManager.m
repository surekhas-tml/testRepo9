//
//  DBManager.m
//  e-Guru
//
//  Created by admin on 29/11/16.
//  Copyright Â© 2016 TATA. All rights reserved.
//

#import "DBManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
static DBManager*  _sharedobject=nil;

@implementation DBManager{
    
    // AppDelegate *appDelegate;
}

#pragma mark - Contact operation
+(DBManager *)sharedobject

{
    @synchronized([DBManager class])
    {
        if (!_sharedobject)
            _sharedobject=[[self alloc] init];
        
        return _sharedobject;
    }
    
    return nil;
}

//- (void)saveContactDraft:(AAADraftMO*)draftObj{
//---- OR ----

- (void)saveContactDraft{
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    AAADraftMO *draft = [NSEntityDescription insertNewObjectForEntityForName:@"Draft" inManagedObjectContext:appDele.persistentContainer.viewContext];
    //    draft.draftID = draftObj.draftID;
    //    draft.userIDLink = draftObj.userIDLink;
    //    draft.toOpportunity.toContact.contactID = draftObj.toOpportunity.toContact.contactID;
    //    draft.toOpportunity.toContact.contactNumber = draftObj.toOpportunity.toContact.contactNumber;
    //    draft.toOpportunity.toContact.emailID = draftObj.toOpportunity.toContact.emailID;
    //    draft.toOpportunity.toContact.firstName = draftObj.toOpportunity.toContact.firstName;
    //    draft.toOpportunity.toContact.lastName = draftObj.toOpportunity.toContact.lastName;
    //    draft.toOpportunity.toContact.panNumber = draftObj.toOpportunity.toContact.panNumber;
    draft.draftID = @"1";
    draft.userIDLink = @"2";
    draft.toOpportunity.toContact.contactID = @"4sdfds";
    draft.toOpportunity.toContact.contactNumber = @"TEST";
    draft.toOpportunity.toContact.emailID = @"TEST";
    draft.toOpportunity.toContact.firstName = @"TEST";
    draft.toOpportunity.toContact.lastName = @"TEST";
    draft.toOpportunity.toContact.panNumber = @"TEST";
    draft.toOpportunity.toContact.toAddress.addressLine1 = @"TEST";
    draft.toOpportunity.toContact.toAddress.addressLine2 = @"TEST";
    draft.toOpportunity.toContact.toAddress.city = @"TEST";
    draft.toOpportunity.toContact.toAddress.district = @"TEST";
    draft.toOpportunity.toContact.toAddress.pin = @"TEST";
    draft.toOpportunity.toContact.toAddress.state = @"TEST";
    draft.toOpportunity.toContact.toAddress.taluka = @"TEST";
    NSError *error = nil;
    if ([appDele.persistentContainer.viewContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    else{
        NSLog(@"CONTACT SAVE SUCCESSFULLY");
    }
}

- (NSArray *)fetchAllDataFromFraft{
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSArray *accountDraftArr = [[NSMutableArray alloc] init];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Draft"];
    NSError *error = nil;
    accountDraftArr = [appDele.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    
    for (AAADraftMO *draft in accountDraftArr) {
        
        NSLog(@"ARR:- %@",[draft valueForKey:@"draftID"]);
    }
    return accountDraftArr;
}

- (void)deleteDataFromDraftWithDraftID:(AAADraftMO *)draftObj{
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDele.persistentContainer.viewContext deleteObject:[draftObj valueForKey:@"draftID"]];
    NSError * error = nil;
    if (![appDele.persistentContainer.viewContext save:&error])
    {
        NSLog(@"Error ! %@", error);
    }
    else{
        NSLog(@"Delete Draft Data");
    }
}

- (void)saveAccountDraft{
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AAADraftMO *draft = [NSEntityDescription insertNewObjectForEntityForName:@"Draft" inManagedObjectContext:appDele.persistentContainer.viewContext];
    draft.draftID = @"TEST";
    draft.userIDLink = @"TEST";
    draft.toOpportunity.toAccount.accountName = @"TEST";
    draft.toOpportunity.toAccount.contactNumber = @"TEST";
    draft.toOpportunity.toAccount.accountType = @"TEST";
    draft.toOpportunity.toAccount.site = @"TEST";
    draft.toOpportunity.toContact.toAddress.addressLine1 = @"TEST";
    draft.toOpportunity.toContact.toAddress.addressLine2 = @"TEST";
    draft.toOpportunity.toContact.toAddress.city = @"TEST";
    draft.toOpportunity.toContact.toAddress.district = @"TEST";
    draft.toOpportunity.toContact.toAddress.pin = @"TEST";
    draft.toOpportunity.toContact.toAddress.state = @"TEST";
    draft.toOpportunity.toContact.toAddress.taluka = @"TEST";
    NSError *error = nil;
    if ([appDele.persistentContainer.viewContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    else{
        NSLog(@"ACCOUNT SAVE SUCCESSFULLY");
    }
}

- (void)saveOptyDraft{
    
    AppDelegate *appDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AAADraftMO *draft = [NSEntityDescription insertNewObjectForEntityForName:@"Draft" inManagedObjectContext:appDele.persistentContainer.viewContext];
    draft.draftID = @"TEST";
    draft.userIDLink = @"TEST";
    draft.toOpportunity.toAccount.accountName = @"TEST";
    draft.toOpportunity.toAccount.contactNumber = @"TEST";
    draft.toOpportunity.toAccount.accountType = @"TEST";
    draft.toOpportunity.toAccount.site = @"TEST";
    draft.toOpportunity.bodyType = @"TEST";
    draft.toOpportunity.competitor = @"TEST";
    draft.toOpportunity.contactFullName = @"TEST";
    draft.toOpportunity.customerAccountID = @"TEST";
    draft.toOpportunity.customerType = @"TEST";
    draft.toOpportunity.financer = @"TEST";
    draft.toOpportunity.financerID = @"TEST";
    draft.toOpportunity.influencer = @"TEST";
    draft.toOpportunity.isLiveDeal = YES;
    draft.toOpportunity.isLost = YES;
    draft.toOpportunity.leadAssignedName = @"TEST";
    draft.toOpportunity.leadAssignedPhoneNumber = @"TEST";
    draft.toOpportunity.leadAssignedPossitionID = @"TEST";
    draft.toOpportunity.leadPossition = @"TEST";
    draft.toOpportunity.license = @"TEST";
    draft.toOpportunity.lob = @"TEST";
    draft.toOpportunity.lostMake = @"TEST";
    draft.toOpportunity.lostModel = @"TEST";
    draft.toOpportunity.lostReson = @"TEST";
    draft.toOpportunity.mmGEO = @"TEST";
    draft.toOpportunity.msgID = @"TEST";
    draft.toOpportunity.opportunityCreatedDate = @"TEST";
    draft.toOpportunity.opportunityName = @"TEST";
    draft.toOpportunity.optyID = @"TEST";
    draft.toOpportunity.pl = @"TEST";
    draft.toOpportunity.ppl = @"TEST";
    draft.toOpportunity.product_ID = @"TEST";
    draft.toOpportunity.productCatagory = @"TEST";
    draft.toOpportunity.productName = @"TEST";
    draft.toOpportunity.productName1 = @"TEST";
    draft.toOpportunity.quantity = @"TEST";
    draft.toOpportunity.reffralType = @"TEST";
    draft.toOpportunity.rev_productID = @"TEST";
    draft.toOpportunity.salesStageName = @"TEST";
    draft.toOpportunity.saleStageUpdatedDate = @"TEST";
    draft.toOpportunity.saletageDate = @"TEST";
    draft.toOpportunity.sourceOfContact = @"TEST";
    draft.toOpportunity.tgmtkmName = @"TEST";
    draft.toOpportunity.tgmTkmPhoneNumber = @"TEST";
    draft.toOpportunity.usageCatagory = @"TEST";
    draft.toOpportunity.vcNumber = @"TEST";
    draft.toOpportunity.vhApplication = @"TEST";
    
    NSError *error = nil;
    if ([appDele.persistentContainer.viewContext save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    else{
        NSLog(@"ACCOUNT SAVE SUCCESSFULLY");
    }
}

- (void)updateDraftWithDraftID:(AAADraftMO *)draftObj{
    
    //First Fetch Data From Database and then Update Draft
    for (int i = 0; i < 10; i++) {
        
        //Compare Draft ID
        if ([[draftObj valueForKey:@"draftID"] isEqualToString:@""]) {
            
            break;
        }
    }
}

@end
