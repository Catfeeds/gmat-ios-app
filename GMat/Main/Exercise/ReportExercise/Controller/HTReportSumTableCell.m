//
//  HTReportSumTableCell.m
//  GMat
//
//  Created by hublot on 16/11/30.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "HTReportSumTableCell.h"
#import "HTReportLineTableView.h"
#import "HTReportModel.h"
#import "NSString+HTString.h"
#import <NSObject+HTTableRowHeight.h>

@interface HTReportSumTableCell ()

@property (nonatomic, strong) UILabel *titleNameLabel;

@property (nonatomic, strong) HTReportLineTableView *progressTableView;

@property (nonatomic, strong) UILabel *detailNameLabel;

@property (nonatomic, strong) HTReportModel *reportModel;

@end

@implementation HTReportSumTableCell

- (void)didMoveToSuperview {
	self.backgroundColor = [UIColor clearColor];
	[self addSubview:self.titleNameLabel];
	[self addSubview:self.segmentedControl];
	[self addSubview:self.progressTableView];
	[self addSubview:self.detailNameLabel];
	[self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.mas_equalTo(self);
		make.height.mas_equalTo(30);
	}];
	[self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.titleNameLabel.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
	}];
	[self.progressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.segmentedControl.mas_bottom).offset(10);
		make.left.right.mas_equalTo(self);
	}];
	[self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(15);
		make.right.mas_equalTo(self).offset(- 15);
		make.top.mas_equalTo(self.progressTableView.mas_bottom).offset(10);
	}];
}

- (void)setModel:(HTReportModel *)model row:(NSInteger)row {
	[self didMoveToSuperview];
	CGFloat titleLabelHeight = 30;
	CGFloat segmentedControlHeight = 30;
	CGFloat progressTableHeight = 0;
	CGFloat detailLabelHeight = 0;
	NSArray *accDataArray = @[model.sc_acc, model.rc_acc, model.cr_acc][_segmentedControl.selectedSegmentIndex];
	NSMutableArray *modelArray = [@[] mutableCopy];
	[accDataArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.count > 1) {
			NSDictionary *scDictionary = @{obj[0]:@([obj[1] integerValue] / 100.0)};
			[modelArray addObject:scDictionary];
		}
	}];
	self.progressTableView.modelArray = modelArray;
	progressTableHeight = self.progressTableView.ht_h;
	[self.progressTableView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(progressTableHeight);
	}];
	NSString *reportString = @"";
	if (self.segmentedControl.selectedSegmentIndex == 0) {
		if (model.sc_data.correctAll >= 80) {
			reportString = @"该科掌握得非常好哦，一般，总分700分对于SC的正确率要求就是80%。与其他科目不同的是，SC的正确率越高，得高分的 概率就越大，所以千万不要让自己的正确率掉下来哦~";
		} else if (model.sc_data.correctAll >= 65) {
			reportString = @"该科掌握得还不错，只需要继续总结分析错题原因，熟练考点，提高正确率即可。";
		} else if (model.sc_data.correctAll >= 50) {
			reportString = @"这部分还需要继续努力呀，SC瓶颈区一般会处在正确率50%-60%左右，要想快速提高正确率，还需要总结分析错题原 因，熟练考点。";
		} else {
			reportString = @"这部分需要努力的地方还很多，建议系统学习所有知识点后，再次练习。";
		}
	} else if (self.segmentedControl.selectedSegmentIndex == 1) {
		if (model.rc_data.correctAll >= 60) {
			reportString = @"该科掌握不错，总分700分一般要求RC单篇正确率达到60%以上。若其他科目也能达到此水平，目标分数可以达到700+以上 了哦~";
		} else if (model.rc_data.correctAll >= 40) {
			reportString = @"该科掌握一般，RC正确率瓶颈一般会处在正确率40%左右，要想快速提高正确率，需要练习长难句，学习回文定位、快 速获取文章结构等做题方法。";
		} else {
			reportString = @"该科基本没掌握，建议系统学习所有知识点后，再次练习。";
		}
	} else if (self.segmentedControl.selectedSegmentIndex == 2) {
		if (model.cr_data.correctAll >= 70) {
			reportString = @"该科掌握得不错，总分700分一般要求CR正确率达到70%以上。继续保持这个正确率就可以了!";
		} else if (model.sc_data.correctAll >= 50) {
			reportString = @"该科掌握一般，CR正确率瓶颈一般会处在正确率50%左右，要想快速提高正确率，需要纠正解题思维模式，熟练解题方 法。";
		} else {
			reportString = @"该科基本没掌握，建议系统学习所有知识点后，再次练习。";
		}
	}
	
	
	
	
	
	
	
	
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*%@", reportString] attributes:nil];
	[attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor ht_colorStyle:HTColorStylePrimaryTheme]} range:NSMakeRange(0, 1)];
	self.detailNameLabel.attributedText = attributedString;
    detailLabelHeight = [self.detailNameLabel.text ht_stringHeightWithWidth:HTSCREENWIDTH - 30 font:self.detailNameLabel.font textView:nil] + 10;
    
    CGFloat modelHeight = titleLabelHeight + segmentedControlHeight + progressTableHeight + detailLabelHeight + 30;
    [model ht_setRowHeightNumber:@(modelHeight) forCellClass:self.class];
}

- (UILabel *)titleNameLabel {
	if (!_titleNameLabel) {
		_titleNameLabel = [[UILabel alloc] init];
		_titleNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_titleNameLabel.font = [UIFont systemFontOfSize:14];
		_titleNameLabel.numberOfLines = 0;
		_titleNameLabel.text = @"准确了解各考点掌握情况, 针对薄弱项知识点突破";
		_titleNameLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleNameLabel;
}

- (UISegmentedControl *)segmentedControl {
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"句子改错SC", @"阅读RC", @"逻辑CR"]];
	}
	return _segmentedControl;
}


- (HTReportLineTableView *)progressTableView {
	if (!_progressTableView) {
		_progressTableView = [[HTReportLineTableView alloc] initWithFrame:CGRectMake(0, 180, HTSCREENWIDTH, 0)];
	}
	return _progressTableView;
}

- (UILabel *)detailNameLabel {
	if (!_detailNameLabel) {
		_detailNameLabel = [[UILabel alloc] init];
		_detailNameLabel.textColor = [UIColor ht_colorStyle:HTColorStylePrimaryTitle];
		_detailNameLabel.font = [UIFont systemFontOfSize:14];
		_detailNameLabel.numberOfLines = 0;
	}
	return _detailNameLabel;
}
@end
