//
//  HTReportModel.h
//  GMat
//
//  Created by hublot on 2016/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Whole_Diffculty650,Cr_Data,Quant_Diffculty650,Rc_Diffculty750,Whole_Diffculty600,Quant_Diffculty600,Sc_Diffculty650,Rc_Diffculty600,Cr_Diffculty750,Sc_Diffculty700,Cr_Diffculty600,Whole_Diffculty750,Whole_Diffculty700,Quant_Diffculty750,Quant_Data,Rc_Diffculty650,Quant_Diffculty700,Sc_Diffculty750,Rc_Diffculty700,Sc_Data,Sc_Diffculty600,Cr_Diffculty650,Cr_Diffculty700,Rc_Data;
@interface HTReportModel : NSObject


@property (nonatomic, strong) Whole_Diffculty650 *whole_diffculty650;

@property (nonatomic, strong) NSArray *sc_acc;

@property (nonatomic, strong) Cr_Data *cr_data;

@property (nonatomic, strong) Whole_Diffculty600 *whole_diffculty600;

@property (nonatomic, strong) Rc_Diffculty750 *rc_diffculty750;

@property (nonatomic, strong) Quant_Diffculty650 *quant_diffculty650;

@property (nonatomic, strong) Quant_Diffculty600 *quant_diffculty600;

@property (nonatomic, strong) Sc_Diffculty650 *sc_diffculty650;

@property (nonatomic, strong) Rc_Diffculty600 *rc_diffculty600;

@property (nonatomic, strong) Cr_Diffculty750 *cr_diffculty750;

@property (nonatomic, strong) NSArray *rc_acc;

@property (nonatomic, strong) Sc_Diffculty700 *sc_diffculty700;

@property (nonatomic, strong) Cr_Diffculty600 *cr_diffculty600;

@property (nonatomic, strong) NSArray *cr_acc;

@property (nonatomic, strong) Whole_Diffculty750 *whole_diffculty750;

@property (nonatomic, strong) Whole_Diffculty700 *whole_diffculty700;

@property (nonatomic, strong) Quant_Data *quant_data;

@property (nonatomic, strong) Quant_Diffculty750 *quant_diffculty750;

@property (nonatomic, strong) Rc_Diffculty650 *rc_diffculty650;

@property (nonatomic, strong) Quant_Diffculty700 *quant_diffculty700;

@property (nonatomic, strong) Sc_Diffculty750 *sc_diffculty750;

@property (nonatomic, strong) Rc_Diffculty700 *rc_diffculty700;

@property (nonatomic, strong) Sc_Data *sc_data;

@property (nonatomic, strong) Sc_Diffculty600 *sc_diffculty600;

@property (nonatomic, strong) Cr_Diffculty650 *cr_diffculty650;

@property (nonatomic, strong) Cr_Diffculty700 *cr_diffculty700;

@property (nonatomic, strong) NSArray *quant_acc;

@property (nonatomic, strong) Rc_Data *rc_data;


@end

@interface Whole_Diffculty650 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Cr_Data : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Quant_Diffculty650 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Rc_Diffculty750 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Whole_Diffculty600 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Quant_Diffculty600 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Sc_Diffculty650 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Rc_Diffculty600 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Cr_Diffculty750 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Sc_Diffculty700 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Cr_Diffculty600 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Whole_Diffculty750 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Whole_Diffculty700 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Quant_Diffculty750 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Quant_Data : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Rc_Diffculty650 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Quant_Diffculty700 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Sc_Diffculty750 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Rc_Diffculty700 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Sc_Data : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Sc_Diffculty600 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Cr_Diffculty650 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Cr_Diffculty700 : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

@interface Rc_Data : NSObject

@property (nonatomic, assign) NSInteger averageTime;

@property (nonatomic, assign) NSInteger correctAll;

@end

