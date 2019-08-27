//
//  seatselectViewController.h
//  sijiedu
//
//  Created by sj on 2018/2/12.
//  Copyright © 2018年 sjjy. All rights reserved.
//

#import "SMScrollView.h"
#import "KyoRowIndexView.h"
#import "selectSeatModel.h"

@interface seatselectViewController : UIViewController

@property (nonatomic, assign)  NSInteger pass;
@property (nonatomic, assign)  NSUInteger row;
@property (nonatomic, assign)  NSUInteger column;
@property (retain, nonatomic)  SMScrollView *myScrollView;
@property (nonatomic, assign)  CGSize seatSize;
@property (assign, nonatomic)  CGFloat seatTop;
@property (assign, nonatomic)  CGFloat seatLeft;
@property (assign, nonatomic)  CGFloat seatBottom;
@property (assign, nonatomic)  CGFloat seatRight;
@property (strong, nonatomic)  UIImage *imgSeatNormal;
@property (strong, nonatomic)  UIImage *imgSeatHadBuy;
@property (strong, nonatomic)  UIImage *imgSeatSelected;
@property (strong, nonatomic)  UIImage *imgSeatblack;
@property (strong, nonatomic)  UIImage *imgSeatNo;
@property (assign, nonatomic)  BOOL rowIndexStick;
@property (strong, nonatomic)  UIColor *rowIndexViewColor;
@property (assign, nonatomic)  NSInteger rowIndexType;
@property (strong, nonatomic)  NSArray *arrayRowIndex;
@property (strong, nonatomic)  UIView *contentView;
@property (strong, nonatomic)  KyoRowIndexView *rowIndexView;
@property (strong, nonatomic)  selectSeatModel *selectSeatMod;
@property (strong, nonatomic)  NSMutableArray *seatdetail;
@property (strong, nonatomic)  NSMutableArray *seatBtnArr;
@end
