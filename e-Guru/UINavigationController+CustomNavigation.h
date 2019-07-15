//
//  UINavigationController+CustomNavigation.h
//  
//
//  Created by Apple on 04/04/19.
//



NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (CustomNavigation)

-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
@end

NS_ASSUME_NONNULL_END
