//
//  ZYSegmentLayout.m
//
//  Created by zxq on 16/1/20.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ZYSegmentLayout.h"

@implementation ZYSegmentLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    if (self.collectionView.bounds.size.height) {
        self.itemSize = self.collectionView.bounds.size;
    }
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
