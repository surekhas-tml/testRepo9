//
//  TableViewSeparator.m
//  e-Guru
//
//  Created by MI iMac04 on 17/11/16.
//  Copyright © 2016 TATA. All rights reserved.
//

#import "TableViewSeparator.h"
#import "UIColor+eGuruColorScheme.h"

@implementation TableViewSeparator

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor tableViewSeparatorColor];
    }
    return self;
}

@end
