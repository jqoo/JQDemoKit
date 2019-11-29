//
//  JQDKActionPlaygroundViewController.m
//  JQDemoKit
//
//  Created by zhangjinquan on 2019/11/29.
//

#import "JQDKActionPlaygroundViewController.h"
#import <Masonry.h>

@interface JQDKActionCell : UICollectionViewCell
{
    UILabel *_textLabel;
}

@property (nonatomic, readonly) UILabel *textLabel;

@end

@implementation JQDKActionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        _textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 3, 3)];
        [self.contentView addSubview:_textLabel];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.font = [UIFont systemFontOfSize:12];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end

@interface JQDKActionPlaygroundViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    UITextView *_outputView;
    NSMutableArray *_actionList;
}

@end

@implementation JQDKActionPlaygroundViewController

- (void)addActionWithTitle:(NSString *)title block:(dispatch_block_t)block {
    if (!title || !block) {
        return;
    }
    [self addActionItem:@[title, [block copy]]];
}

- (void)addActionWithTitle:(NSString *)title selector:(SEL)selector {
    if (!title || !selector) {
        return;
    }
    [self addActionItem:@[title, [NSValue valueWithPointer:selector]]];
}

- (void)addActionItem:(NSArray *)actionItem {
    if (!_actionList) {
        _actionList = [NSMutableArray array];
    }
    [_actionList addObject:actionItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/3 - 10, 30);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)
                                                          collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[JQDKActionCell class] forCellWithReuseIdentifier:@"JQDKActionCell"];

    _outputView = [[UITextView alloc] init];
    [self.view addSubview:_outputView];
    _outputView.editable = NO;
    _outputView.font = [UIFont systemFontOfSize:10];
    _outputView.backgroundColor = [UIColor blackColor];
    _outputView.textColor = [UIColor whiteColor];
    
    [_outputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self->_collectionView.mas_bottom);
    }];
    
    [self loadActions];
    [_collectionView reloadData];
}

- (void)print:(NSString *)text {
    NSRange endRange = NSMakeRange([_outputView.text length], 0);
    [_outputView scrollRangeToVisible:endRange];
    _outputView.selectedRange = endRange;
    [_outputView insertText:[NSString stringWithFormat:@"\n%@", text]];
    [_outputView scrollRangeToVisible:NSMakeRange([_outputView.text length], 0)];
}

- (void)printf:(NSString *)fmt, ... {
    va_list args;
    va_start(args, fmt);
    
    NSString *text = [[NSString alloc] initWithFormat:fmt arguments:args];
    [self print:text];
    
    va_end(args);
}

- (void)loadActions {
}

- (void)xselect:(id)sender {
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_actionList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JQDKActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JQDKActionCell" forIndexPath:indexPath];
    NSArray *actionItem = [_actionList objectAtIndex:indexPath.row];
    cell.textLabel.text = actionItem[0];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSArray *actionItem = [_actionList objectAtIndex:indexPath.row];
    id action = actionItem[1];
    if ([action isKindOfClass:[NSValue class]]) {
        [self qmui_performSelector:(SEL)[(NSValue *)action pointerValue] withPrimitiveReturnValue:NULL];
    }
    else if ([action isKindOfClass:NSClassFromString(@"NSBlock")]) {
        ((dispatch_block_t)action)();
    }
}

@end
