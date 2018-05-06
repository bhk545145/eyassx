//
//  BookListViewCell.m
//  MACProject
//
//  Created by 白洪坤 on 2018/5/5.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import "BookListViewCell.h"
#import "UIButton+LXMImagePosition.h"
@implementation BookListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_authorLable setImagePosition:LXMImagePositionLeft spacing:5.0f];
}

@end
