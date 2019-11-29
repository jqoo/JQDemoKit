//
//  JQDKActionPlaygroundViewController.h
//  JQDemoKit
//
//  Created by zhangjinquan on 2019/11/29.
//

#import "QMUICommonViewController.h"

@interface JQDKActionPlaygroundViewController : QMUICommonViewController

- (void)addActionWithTitle:(NSString *)title block:(dispatch_block_t)block;
- (void)addActionWithTitle:(NSString *)title selector:(SEL)selector;

- (void)loadActions;

- (void)print:(NSString *)text;

- (void)printf:(NSString *)fmt, ...;

@end
