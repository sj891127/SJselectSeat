//
//  seatselectViewController.m
//  sijiedu
//
//  Created by sj on 2018/2/12.
//  Copyright © 2018年 sjjy. All rights reserved.
//

#import "seatselectViewController.h"

@interface seatselectViewController ()<UIScrollViewDelegate>

@end

@implementation seatselectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"选座";
    [self initData];
    [self loadSeat];
    [self drawRowIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    self.seatBtnArr=[[NSMutableArray alloc]init];
    self.seatdetail=[[NSMutableArray alloc]init];
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"seatInfo" ofType:@"json"]];
    NSMutableArray *jsonArr = [[NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil]objectForKey:@"seatInfo"];
    for (int i=0; i<jsonArr.count; i++) {
        self.selectSeatMod=[[selectSeatModel alloc]initWithDictionary:[jsonArr objectAtIndex:i] error:nil];
        [self.seatdetail addObject:self.selectSeatMod];
    }
    self.pass=2;
    self.row=4;
    self.column=4+self.pass;
}

-(void)loadSeat{
    self.seatSize = CGSizeMake(30*SCALE, 30*SCALE);
    self.seatTop = 20*SCALE;
    self.seatLeft = 20*SCALE;
    self.seatBottom = 20*SCALE;
    self.seatRight = 20*SCALE;
    self.myScrollView.zoomScale = 1.0;
    self.imgSeatNormal = [UIImage imageNamed:@"icon-zuowei"];
    self.imgSeatHadBuy = [UIImage imageNamed:@"icon-zuowei-red"];
    self.imgSeatSelected = [UIImage imageNamed:@"icon-zuowei-blue"];
    self.imgSeatblack=[UIImage imageNamed:@"heiban"];
    self.imgSeatNo=[UIImage imageNamed:@"icon-zuowe-n"];
    self.rowIndexStick = YES;
    NSMutableDictionary *dictSeatState = [NSMutableDictionary dictionary];
    for (NSInteger row = 0; row < self.row; row++) {
        NSMutableArray *arrayState = [NSMutableArray array];
        for (NSInteger column = 0; column < self.column; column++) {
            [arrayState addObject:@(KyoCinameSeatStateNormal)];
        }
        [dictSeatState setObject:arrayState forKey:@(row)];
    }
    self.myScrollView.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * self.myScrollView.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * self.myScrollView.zoomScale);
    if (!self.contentView) {
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    }
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    self.contentView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentView.clipsToBounds = YES;
    self.myScrollView = [[SMScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.myScrollView.maximumZoomScale = 1.5;
    self.myScrollView.delegate = self;
    self.myScrollView.backgroundColor=[UIColor redColor];
    self.myScrollView.showsVerticalScrollIndicator = FALSE;
    self.myScrollView.showsHorizontalScrollIndicator = FALSE;
    self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myScrollView.contentSize = self.contentView.frame.size;
    self.myScrollView.alwaysBounceVertical = YES;
    self.myScrollView.alwaysBounceHorizontal = YES;
    self.myScrollView.stickToBounds = YES;
    [self.myScrollView addViewForZooming:self.contentView];
    [self.myScrollView scaleToFit];
    self.myScrollView.backgroundColor=UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.myScrollView];
    self.myScrollView.contentSize = CGSizeMake((self.seatLeft + self.column * self.seatSize.width + self.seatRight) * self.myScrollView.zoomScale,(self.seatTop + self.row * self.seatSize.height + self.seatBottom) * self.myScrollView.zoomScale);
    //画座位
    [self drawSeat];
}
//画座位
- (void)drawSeat{
    [self.seatBtnArr removeAllObjects];
    for (int j=0; j<self.seatdetail.count; j++) {
        self.selectSeatMod=[self.seatdetail objectAtIndex:j];
        NSInteger column1=j%self.column;
        NSInteger row=j/self.column;
        UIButton *btnSeat = nil;
        btnSeat = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSeat.tag = j;
        [btnSeat addTarget:self action:@selector(btnSeatTouchIn:) forControlEvents:UIControlEventTouchUpInside];
        [self.seatBtnArr addObject:btnSeat];
        [self.contentView addSubview:btnSeat];
        btnSeat.frame = CGRectMake((column1+1)*self.seatSize.width, row*self.seatSize.height+10*SCALE, self.seatSize.width, self.seatSize.height);
        if ([self.selectSeatMod.type isEqualToString:@"位置"]) {
            if (self.selectSeatMod.status==0) {
                [btnSeat setImage:self.imgSeatNormal forState:UIControlStateNormal];
            }else{
                [btnSeat setImage:self.imgSeatHadBuy forState:UIControlStateNormal];
                btnSeat.userInteractionEnabled=NO;
            }
        }else if([self.selectSeatMod.type isEqualToString:@"黑板"]){
            [btnSeat setImage:self.imgSeatblack forState:UIControlStateNormal];
            btnSeat.userInteractionEnabled=NO;
        }else if ([self.selectSeatMod.type isEqualToString:@"保留位置"]){
            [btnSeat setImage:self.imgSeatHadBuy forState:UIControlStateNormal];
            btnSeat.userInteractionEnabled=NO;
        }else if ([self.selectSeatMod.type isEqualToString:@"不可选位置"]){
            [btnSeat setImage:self.imgSeatNo forState:UIControlStateNormal];
            btnSeat.userInteractionEnabled=NO;
        }else{
            btnSeat.userInteractionEnabled=NO;
        }
    }
}

-(void)drawRowIndex{
    //画座位行数提示
    self.rowIndexView = [[KyoRowIndexView alloc] init];
    self.rowIndexView.backgroundColor = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
    [self.contentView addSubview:self.rowIndexView];
    [self.contentView bringSubviewToFront:self.rowIndexView];
    [self.myScrollView bringSubviewToFront:self.rowIndexView];
    self.rowIndexView.row=self.seatdetail.count/self.column;
    self.rowIndexView.width = kRowIndexWith;
    self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
    self.rowIndexView.frame = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? self.myScrollView.contentOffset.x : 0)) / self.myScrollView.zoomScale, self.seatTop-10, kRowIndexWith, self.rowIndexView.row * self.seatSize.height);
    self.rowIndexView.rowIndexType = self.rowIndexType;
    self.rowIndexView.arrayRowIndex = self.arrayRowIndex;
    self.rowIndexView.hidden = NO;
}

//座位点击
- (void)btnSeatTouchIn:(UIButton *)btn {
    [self loadSeat];
    for (int i=0; i<self.seatdetail.count; i++) {
        self.selectSeatMod=[self.seatdetail objectAtIndex:i];
        if (btn.tag+1==self.selectSeatMod.seq) {
            if ([self.selectSeatMod.type isEqualToString:@"位置"]) {
                if (self.selectSeatMod.status==0) {
                    NSLog(@"row====%ld,col====%ld,seq====%ld",self.selectSeatMod.row,self.selectSeatMod.col,self.selectSeatMod.seq);
                }
            }
            break;
        }
    }
    [self drawselectseat :btn.tag+1];
}

-(void)drawselectseat :(NSInteger)tag1{
    for (int j=0; j<self.seatdetail.count; j++) {
        self.selectSeatMod=[self.seatdetail objectAtIndex:j];
        if (tag1==self.selectSeatMod.seq) {
            UIButton *btnSeat=[self.seatBtnArr objectAtIndex:j];
            [btnSeat setImage:self.imgSeatSelected forState:UIControlStateNormal];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myScrollView.viewForZooming;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //画座位行数提示
    if (!self.rowIndexView) {
        self.rowIndexView = [[KyoRowIndexView alloc] init];
        self.rowIndexView.backgroundColor = self.rowIndexViewColor ? : kRowIndexViewDefaultColor;
        [self.myScrollView addSubview:self.rowIndexView];
    }
    [self.contentView bringSubviewToFront:self.rowIndexView];
    [self.myScrollView bringSubviewToFront:self.rowIndexView];
    self.rowIndexView.row = self.row;
    self.rowIndexView.width = kRowIndexWith;
    self.rowIndexView.rowIndexViewColor = self.rowIndexViewColor;
    self.rowIndexView.frame = CGRectMake((kRowIndexSpace + (self.rowIndexStick ? self.myScrollView.contentOffset.x : 0)) < 2 ? 2:(kRowIndexSpace + (self.rowIndexStick ? self.myScrollView.contentOffset.x : 0)) / self.myScrollView.zoomScale, self.seatTop-10*SCALE,
                                         kRowIndexWith,
                                         self.rowIndexView.row * self.seatSize.height);
    self.rowIndexView.rowIndexType = self.rowIndexType;
    self.rowIndexView.arrayRowIndex = self.arrayRowIndex;
    self.rowIndexView.hidden = NO;
}

@end
