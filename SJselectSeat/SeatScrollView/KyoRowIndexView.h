//
//  KyoRowIndexView.h
//  sijiedu
//
//  Created by sj on 2018/2/12.
//  Copyright © 2018年 sjjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum : NSInteger {
    KyoCinameSeatRowIndexTypeNumber = 0,    //默认，显示数字
    KyoCinameSeatRowIndexTypeLetter = 1,    //显示字母
}KyoCinameSeatRowIndexType; //座位左边行号提示样式

@interface KyoRowIndexView : UIView
@property (nonatomic, assign) NSUInteger row;
@property (assign, nonatomic) CGFloat width;
@property (weak, nonatomic) UIColor *rowIndexViewColor;
@property (assign, nonatomic) KyoCinameSeatRowIndexType rowIndexType;
@property (strong, nonatomic) NSArray *arrayRowIndex; //座位号左边行号提示（用它则忽略rowindextype）
@end
