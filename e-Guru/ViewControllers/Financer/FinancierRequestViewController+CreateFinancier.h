//
//  FinancierRequestViewController+CreateFinancier.h
//  e-guru
//
//  Created by Shashi on 16/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "FinancierRequestViewController.h"
#import "UtilityMethods.h"
#import "EGDraftStatus.h"

@interface FinancierRequestViewController (CreateFinancier)

- (void)saveFinancier:(EGDraftStatus) draftStatus;
- (void)updateFinancier:(EGDraftStatus) draftStatus;


@end
