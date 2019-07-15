//
//  ManageOpportunityViewController+SearchOpportunity.h
//  e-Guru
//
//  Created by Juili on 03/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "ManageOpportunityViewController.h"

@interface ManageOpportunityViewController (SearchOpportunity)<SearchOpportunityViewDelegate>

- (void)searchOpportunityForFilter:(EGSearchOptyFilter *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size;

@end


