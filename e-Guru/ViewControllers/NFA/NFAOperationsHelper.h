//
//  NFAOperationsHelper.h
//  e-guru
//
//  Created by Juili on 28/02/17.
//  Copyright © 2017 TATA. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Constant.h"
#import "EGNFA.h"
#import "EGSearchNFAFilter.h"
#import "CreateNFAViewController.h"
#import "NFACollectionViewContainerViewController.h"
@class NFACollectionViewContainerViewController,SearchNFAViewController;
@interface NFAOperationsHelper : NSObject
@property (weak,nonatomic) UIViewController* senderVC;
- (void)searchNFAForFilter:(EGSearchNFAFilter *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size fromVC:(__weak UIViewController *)senderVC;
-(NSMutableArray *)setActionsArrayForNFAWithStatus:(NSString *)nfaStatus andOpportunitySaleStage:(NSString *)opportunityStage;
-(void)UpdateNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC;
-(void)copyNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC;
-(void)cancelNFAFor:(EGNFA *)NFAObject fromVC:(__weak UIViewController *)senderVC;
@end
