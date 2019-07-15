//
//  EGsearchByValues.h
//  e-Guru
//
//  Created by swapnil katwe on 02/12/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum radioButtonSelected
{
    radioOpportunityButton = 0,
    radioCantactButton,
    radioAccountButton
}radioButtons;

@interface EGsearchByValues : NSObject
@property (nullable,copy,nonatomic) NSString * stringToSearch;
@property (assign,nonatomic) radioButtons radioButtonSelected;
@end
