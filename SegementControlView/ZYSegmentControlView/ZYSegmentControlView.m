//
//  ZYSegmentControlView.m
//
//  Created by zxq on 16/1/20.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZYSegmentControlView.h"
#import "ZYSegmentLayout.h"

static NSInteger TitleScrollViewHeight = 40;
static NSInteger TitlleFontSize = 14;
static NSInteger TitleMargin = 10;
static NSInteger ButtonMargin = 0;
static NSString *const SegmentControlViewCellIdentifier = @"SegmentControlViewCellIdentifier";

@interface ZYSegmentControlView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView                          *titleScollView;
@property (nonatomic, strong, readwrite) UICollectionView           *contentScrollView;
@property (nonatomic, strong) UIView                                *bottomMoveLine;        //滑动线
@property (nonatomic, strong) UIView                                *titleViewBottomLine;   //标题栏底下固定线

@property (nonatomic, strong) NSMutableArray                        *titleButtonArray;
@property (nonatomic, strong) NSMutableArray                        *titleWidthArray;
@property (nonatomic, strong) NSMutableArray                        *titleStringArray;

@property (nonatomic, strong) NSMutableArray                        *pageViewArray;

@property (nonatomic, assign) CGFloat                               buttonMargin;   //button之间的距离
@property (nonatomic, assign, readwrite) NSUInteger                 currentPage;

@property (nonatomic, assign) BOOL isWidthGreateThanHeight;


@end

@implementation ZYSegmentControlView{
    CGFloat _lastOffset;
}

#pragma mark - public

- (void)setTitles:(NSArray *)titles pageViews:(NSArray*)views
{
    [self setTitles:titles];
    [self setPageViews:views];
    [self refreshUI];
    [self.contentScrollView reloadData];
}

#pragma mark - lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isShowTitleViewWhenOnlyOneItem = NO;
        _underLineIsFitToTextWidth = YES;
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _isShowTitleViewWhenOnlyOneItem = NO;
        _underLineIsFitToTextWidth = YES;
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews
{
    //判断屏幕是否旋转
    _contentScrollView.contentInset = UIEdgeInsetsZero;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        if (!self.isWidthGreateThanHeight) {
            [self refreshUI];
            [self updateTitleButtonFrame];
            [self.pageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *view = obj;
                view.frame = CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            }];
            self.contentScrollView.contentOffset = CGPointMake(_currentPage * self.contentScrollView.frame.size.width, 0);
        }
        self.isWidthGreateThanHeight = YES;
    }else{
        if (self.isWidthGreateThanHeight) {
            [self refreshUI];
            [self updateTitleButtonFrame];
            [self.pageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *view = obj;
                view.frame = CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            }];
            self.contentScrollView.contentOffset = CGPointMake(_currentPage * self.contentScrollView.frame.size.width, 0);
        }
        self.isWidthGreateThanHeight = NO;
    }
}

#pragma mark - private

- (void)createUI
{
    self.titleMargin = TitleMargin;
    if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
        self.isWidthGreateThanHeight = YES;
    }
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentScrollView];
    [self addSubview:self.titleScollView];
    [self addSubview:self.titleViewBottomLine];
    [self.titleScollView addSubview:self.bottomMoveLine];

}

- (void)refreshUI
{
    if ((self.titleButtonArray.count == 1 && _isShowTitleViewWhenOnlyOneItem) || self.titleButtonArray.count > 1) {
        self.titleScollView.frame  = CGRectMake(0, 0, self.frame.size.width, TitleScrollViewHeight);
//        ((UICollectionViewFlowLayout*)self.contentScrollView.collectionViewLayout).itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - TitleScrollViewHeight);
        self.contentScrollView.frame = CGRectMake(0, TitleScrollViewHeight, self.frame.size.width, self.frame.size.height - TitleScrollViewHeight);
        self.titleViewBottomLine.frame = CGRectMake(0, TitleScrollViewHeight - 0.5, self.frame.size.width, 0.5);
        if (self.underLineIsFitToTextWidth) {
            self.bottomMoveLine.frame = CGRectMake((_underLineIsFitToTextWidth?self.titleMargin/2:0) + self.buttonMargin, TitleScrollViewHeight - 2, [self.titleWidthArray[0] floatValue], 2);
        }else{
            self.bottomMoveLine.frame = CGRectMake(0, TitleScrollViewHeight - 2, [self.titleWidthArray[0] floatValue], 2);
        }
        
    
        
    }else{
        self.titleScollView.frame  = CGRectMake(0, 0, self.frame.size.width, 0);
        self.contentScrollView.frame = self.bounds;
    }
}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UIButton *)titleButton
{
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = titleButton.center.x - self.frame.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScollView.contentSize.width - self.frame.size.width + self.buttonMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)updateTitleButtonFrame
{
    if (self.titleStringArray.count == 0) {
        return;
    }
    
    [self calculateTitleWidth:self.titleStringArray];
    
    for (NSInteger i = 0; i < self.titleButtonArray.count; i++) {
        UIButton *but = self.titleButtonArray[i];
        UIButton *lastBut = nil;
        if (i > 0) {
            lastBut = self.titleButtonArray[i - 1];
        }
        
        CGFloat buttonX = lastBut?CGRectGetMaxX(lastBut.frame):0;
        buttonX += self.buttonMargin;
        but.frame = CGRectMake(buttonX, 0, [self.titleWidthArray[i] floatValue], TitleScrollViewHeight);
    }
    
    UIButton *lastButton = [self.titleButtonArray lastObject];

    if (_currentPage >= self.titleWidthArray.count) {
        return;
    }

    self.titleScollView.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame), 0);
    self.titleViewBottomLine.frame = CGRectMake(0, TitleScrollViewHeight - 0.5, CGRectGetMaxX(lastButton.frame), 0.5);
    
    if (self.underLineIsFitToTextWidth) {
        self.bottomMoveLine.frame = CGRectMake((_underLineIsFitToTextWidth?self.titleMargin/2.0:0) + self.buttonMargin, TitleScrollViewHeight - 2, [self.titleWidthArray[_currentPage] floatValue], 2);
    }else{
        self.bottomMoveLine.frame = CGRectMake(0, TitleScrollViewHeight - 2, [self.titleWidthArray[_currentPage] floatValue], 2);
    }
    [self moveBottomLineAnimatedWithIndex:_currentPage time:0];
    
}

- (void)setTitles:(NSArray*)titles
{
    if (![titles isKindOfClass:[NSArray class]]) {
        return;
    }
    
    [self.titleButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleButtonArray removeAllObjects];
    
    [self.titleStringArray removeAllObjects];
    [self.titleStringArray addObjectsFromArray:titles];
    
    [self calculateTitleWidth:titles];
    
    NSUInteger count = titles.count;
        
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if (i == 0) {
            if (self.segmentColor) {
                [button setTitleColor:self.segmentColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }else{
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }

        button.titleLabel.font = [UIFont systemFontOfSize:TitlleFontSize];
        UIButton *lastButton = [self.titleButtonArray lastObject];
        CGFloat buttonX = lastButton?CGRectGetMaxX(lastButton.frame):0;
        buttonX += self.buttonMargin;
        button.frame = CGRectMake(buttonX, 0, [self.titleWidthArray[i] floatValue] + (_underLineIsFitToTextWidth?self.titleMargin:0), TitleScrollViewHeight);
        [button addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.titleScollView addSubview:button];
        [self.titleButtonArray addObject:button];
    }
    UIButton *lastButton = [self.titleButtonArray lastObject];
    self.titleScollView.contentSize = CGSizeMake(CGRectGetMaxX(lastButton.frame), 0);
    self.titleScollView.showsHorizontalScrollIndicator = NO;
}

- (void)setSelectedTitleWithIndex:(NSInteger)index
{
    if (index == _currentPage) {
        [self moveBottomLineAnimatedWithIndex:index time:0.1];
        return;
    }
    
    for (NSInteger i = 0; i < self.titleButtonArray.count; i++) {
        UIButton *button = self.titleButtonArray[i];
        if (i == index) {
            if (self.segmentColor) {
                [button setTitleColor:self.segmentColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [self setLabelTitleCenter:button];
        }else{
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    [self moveBottomLineAnimatedWithIndex:index time:0.3];
    if (self.scrollPageBlock) {
        self.scrollPageBlock(index);
    }
    _currentPage = index;
}

- (void)moveBottomLineAnimatedWithIndex:(NSInteger)index time:(NSTimeInterval)time
{
    CGFloat buttonX = 0;
    
    if (self.underLineIsFitToTextWidth) {
        UIButton *titleButton = self.titleButtonArray[index];
        buttonX = titleButton.frame.origin.x + self.titleMargin/2.0f;
    }else{
        for (NSInteger i = 0; i < self.titleWidthArray.count; i++) {
            if (index == i) {
                break;
            }else{
                buttonX += [self.titleWidthArray[i] floatValue];
            }
        }
    }
    
    if (buttonX + [self.titleWidthArray[index] floatValue] > self.contentScrollView.contentSize.width) {
        assert(NO);
    }
    
    if (self.bottomMoveLine.frame.origin.x != buttonX) {
        [UIView animateWithDuration:time animations:^{
            self.bottomMoveLine.frame = CGRectMake(buttonX, self.bottomMoveLine.frame.origin.y, [self.titleWidthArray[index] floatValue], self.bottomMoveLine.frame.size.height);
        }completion:^(BOOL finished) {
        }];
    }
}


- (void)moveBottomLine:(CGFloat)offsetX
{
    NSInteger leftButtonIndex = offsetX / self.frame.size.width;
    NSInteger rightButtonIndex = leftButtonIndex + 1;
    
    CGFloat widthDelta = 0;
    CGFloat centerDelta = 0;
    
    CGFloat leftWidth = [self.titleWidthArray[leftButtonIndex] floatValue];
    CGFloat rightWidth = 0;
    
    if (rightButtonIndex < self.titleWidthArray.count) {
        rightWidth = [self.titleWidthArray[rightButtonIndex] floatValue];
    }
    
    widthDelta = rightWidth - leftWidth;
    
    UIButton *leftButton = self.titleButtonArray[leftButtonIndex];
    UIButton *rightButton = nil;
    if (rightButtonIndex < self.titleButtonArray.count) {
        rightButton = self.titleButtonArray[rightButtonIndex];
    }
    
    centerDelta = rightButton.frame.origin.x - leftButton.frame.origin.x;
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffset;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / self.frame.size.width;    //offsetDelta / self.frame.size.width 为移动的比例， 乘以centerDelta表示下划线移动距离
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / self.frame.size.width;  //offsetDelta / self.frame.size.width 为移动的比例， 乘以widthDelta表示宽度变化值
    
    CGFloat finalWidth = self.bottomMoveLine.frame.size.width + underLineWidth;
    CGFloat finalX = self.bottomMoveLine.frame.origin.x + underLineTransformX;
    self.bottomMoveLine.frame = CGRectMake(finalX, self.bottomMoveLine.frame.origin.y, finalWidth, self.bottomMoveLine.frame.size.height);
    
}

- (void)calculateTitleWidth:(NSArray*)titles
{
    CGFloat totalWidth = 0;
    
    [self.titleWidthArray removeAllObjects];
    
    if (self.underLineIsFitToTextWidth) {
        for (NSString *title in titles) {
            
            if (![title isKindOfClass:[NSString class]]) {
                continue;
            }
            
            CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TitlleFontSize]} context:nil];
            totalWidth += titleBounds.size.width;
            totalWidth += self.titleMargin;
            [self.titleWidthArray addObject:@(titleBounds.size.width)];
        }
        
        if (totalWidth > self.frame.size.width) {
            self.buttonMargin = ButtonMargin;
        }else{
            CGFloat margin = (self.frame.size.width - totalWidth) / (titles.count + 1);
            self.buttonMargin = margin < ButtonMargin ? ButtonMargin : margin;
        }
        
        self.titleScollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.buttonMargin);
        
    }else{
        self.buttonMargin = 0;
        CGFloat width = self.frame.size.width / titles.count;
        for (NSInteger i = 0; i < titles.count; i++) {
            [self.titleWidthArray addObject:@(width)];
        }
    }
}


- (void)setPageViews:(NSArray*)views
{
    [self.pageViewArray removeAllObjects];
    if ([views isKindOfClass:[NSArray class]]) {
        [self.pageViewArray addObjectsFromArray:views];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(views.count, 0);
}

#pragma mark - response Action

- (void)titleButtonClicked:(UIButton*)sender
{
    CGRect frame = self.contentScrollView.frame;
    frame.origin.x = frame.size.width * sender.tag;
    frame.origin.y = 0;
    [self.contentScrollView scrollRectToVisible:frame animated:YES];
    [self setSelectedTitleWithIndex:sender.tag];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentControlViewCellIdentifier forIndexPath:indexPath];
    
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *view = self.pageViewArray[indexPath.row];
    view.frame = CGRectMake(0, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
    
    [cell.contentView addSubview:view];
    
    return cell;
}


#pragma mark scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {    //手势翻页的才需要调moveBottomLine
        [self moveBottomLine:scrollView.contentOffset.x];
    }
    _lastOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{    
    NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
    
    [self setSelectedTitleWithIndex:index];
    
    if (self.scrollPageBlock) {
        self.scrollPageBlock(index);
    }
}

#pragma mark - setters

- (void)setSegmentColor:(UIColor *)segmentColor
{
    if ([segmentColor isKindOfClass:[UIColor class]]) {
        self.bottomMoveLine.backgroundColor = segmentColor;
        for (UIButton *button in self.titleButtonArray) {
            [button setTitleColor:segmentColor forState:UIControlStateNormal];
        }
    }
    _segmentColor = segmentColor;
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor
{
    if ([segmentBackgroundColor isKindOfClass:[UIColor class]]) {
        self.titleScollView.backgroundColor = segmentBackgroundColor;
        _segmentBackgroundColor = segmentBackgroundColor;
    }
}

#pragma mark - getters

- (UIScrollView*)titleScollView
{
    if (!_titleScollView) {
        _titleScollView = [[UIScrollView alloc] init];
    }
    return _titleScollView;
}

- (UICollectionView*)contentScrollView
{
    if (!_contentScrollView) {
        ZYSegmentLayout *layout = [[ZYSegmentLayout alloc] init];
        _contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [_contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SegmentControlViewCellIdentifier];
    }
    return _contentScrollView;
}

- (UIView*)bottomMoveLine
{
    if (!_bottomMoveLine) {
        _bottomMoveLine = [[UIView alloc] init];
        _bottomMoveLine.backgroundColor = [UIColor blackColor];
    }
    return _bottomMoveLine;
}

- (UIView*)titleViewBottomLine
{
    if (!_titleViewBottomLine) {
        _titleViewBottomLine = [[UIView alloc] init];
        _titleViewBottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleViewBottomLine;
}

- (NSMutableArray*)titleButtonArray
{
    if (!_titleButtonArray) {
        _titleButtonArray = [[NSMutableArray alloc] init];
    }
    return _titleButtonArray;
}


- (NSMutableArray*)pageViewArray
{
    if (!_pageViewArray) {
        _pageViewArray = [[NSMutableArray alloc] init];
    }
    return _pageViewArray;
}

- (NSMutableArray*)titleWidthArray
{
    if (!_titleWidthArray) {
        _titleWidthArray = [[NSMutableArray alloc] init];
    }
    return _titleWidthArray;
}

- (NSMutableArray*)titleStringArray
{
    if (!_titleStringArray) {
        _titleStringArray = [[NSMutableArray alloc] init];
    }
    return _titleStringArray;
}

@end
