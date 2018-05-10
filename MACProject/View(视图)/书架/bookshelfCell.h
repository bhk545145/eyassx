//
//  bookshelfCell.h
//  MACProject
//
//  Created by 白洪坤 on 2018/5/10.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookshelfCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UILabel *titile;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *lastChapter;

@end
