//
//  BookListViewCell.h
//  MACProject
//
//  Created by 白洪坤 on 2018/5/5.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *shortIntroLable;
@property (weak, nonatomic) IBOutlet UIButton *authorLable;
@end
