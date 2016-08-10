//
//  ZYSegmentControlView.h
//
//  Created by zxq on 16/1/20.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define lc(o) o.layer.borderColor = [UIColor redColor].CGColor;o.layer.borderWidth = 1

@interface ZYSegmentControlView : UIView

@property (nonatomic, assign) BOOL isShowTitleViewWhenOnlyOneItem;              //当只有一项时，是否显示顶部tab栏。默认NO
@property (nonatomic, assign) BOOL underLineIsFitToTextWidth;                   //下划线是否和文字宽度对应。默认YES。 NO情况：button宽度为view.width/count，buttonMargin为0
@property (nonatomic, strong) UIColor *segmentColor;                            //标题下划线颜色
@property (nonatomic, strong) UIColor *segmentBackgroundColor;                  //背景色

@property (nonatomic, assign) CGFloat titleMargin;                              //buttonWidth = title.string.length + titleMargin

@property (nonatomic, strong, readonly) UICollectionView *contentScrollView;
@property (nonatomic, assign, readonly) NSUInteger currentPage;

@property (nonatomic, copy) void(^scrollPageBlock)(NSInteger);                  //翻页回调

- (void)setTitles:(NSArray *)titles pageViews:(NSArray*)views;

@end
