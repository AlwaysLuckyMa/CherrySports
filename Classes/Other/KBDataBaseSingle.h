//
//  KBDataBaseSingle.h
//  LuoXun
//
//  Created by dkb on 17/2/9.
//  Copyright © 2017年 dkb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "StartModel.h"

@interface KBDataBaseSingle : NSObject

+ (instancetype)sharDataBase;

@property (nonatomic, strong)FMDatabase *db;

- (void)openDB;
// recomend
#pragma mark 插入图片数据
- (void)insertNewTimeModel:(StartModel *)timeModel;
#pragma mark 查询Id
-(NSMutableArray *)selectFeaturedData:(NSString *)myId;
#pragma mark 查询Featured数据
-(NSMutableArray *)selectFeaturedAllData;
#pragma mark 销毁表格
-(void)dropTable;
#pragma mark - 删除收藏数据
-(void)deleteMovieData:(NSString *)myId;

- (void)insertNewArrModel:(NSString *)str;
- (NSMutableArray *)selecturlAllData;
@end
