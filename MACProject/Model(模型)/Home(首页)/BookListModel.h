//
//  BookListModel.h
//  MACProject
//
//  Created by 白洪坤 on 2018/5/5.
//  Copyright © 2018年 com.mackun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookListModel : NSObject
/**
 *  书分类id
 */
@property(nonatomic,copy) NSString* _id;

/**
 *  书分类标题
 */
@property(nonatomic,copy) NSString* title;
/**
 *  type 0：显示 1：不显示
 */
@property(nonatomic,assign) NSInteger type;
@end
