//
//  ManageFianancierViewController+searchFianancier.h
//  e-guru
//
//  Created by apple on 24/12/18.
//  Copyright © 2018 TATA. All rights reserved.
//

#import "ManageFianancierViewController.h"

@interface ManageFianancierViewController (searchFianancier)<SearchFinancierViewDelegate>

- (void)searchOpportunityForFilter:(EGSearchFinancierOptyFilterModel *) filter withOffset:(unsigned long) offset withSize:(unsigned long) size;

-(void)searchView_Configuration;

@end
