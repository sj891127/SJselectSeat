//
//  selectSeatModel.h
//  SJselectSeat
//
//  Created by shenjie on 2019/8/26.
//  Copyright © 2019 shenjie. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface selectSeatModel : JSONModel
@property(nonatomic,assign)NSInteger seq;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)NSInteger col;
@end

NS_ASSUME_NONNULL_END
