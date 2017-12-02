//
//  THCourseTeacherDetailController.m
//  TingApp
//
//  Created by hublot on 16/8/24.
//  Copyright © 2016年 thinku. All rights reserved.
//

#import "THCourseTeacherDetailController.h"
#import "THTableButton.h"
#import <UITableView+HTSeparate.h>
#import "THTeacherDetailHeaderCell.h"
#import "THTeacherDetailInfoCell.h"
#import "THTeacherDetailAlertView.h"
#import "HTRandomNumberManager.h"


@interface THCourseTeacherDetailController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) THTableButton *inviteButton;

@end

@implementation THCourseTeacherDetailController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initializeDataSource];
	[self initializeUserInterface];
}

- (void)initializeDataSource {
	
}

- (void)initializeUserInterface {
	self.navigationItem.title = self.model.teacherName;
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.inviteButton];
}

+ (void)invideButtonTeapedWithModel:(THCourseTogetherTeacherModel *)model complete:(void(^)(void))complete {
    [THTeacherDetailAlertView showTeacherAlert:^(NSString *firstTextFieldString, NSString *secondTextFieldString) {
		HTNetworkModel *networkModel = [[HTNetworkModel alloc] init];
		networkModel.autoAlertString = @"预约老师中";
		networkModel.offlineCacheStyle = HTCacheStyleNone;
		networkModel.autoShowError = true;
		[HTRequestManager requestInvideTeacherWithNetworkModel:networkModel teacherIdString:model.teacherId usernameString:firstTextFieldString phoneNumberString:secondTextFieldString courseTitleString:model.title complete:^(id response, HTError *errorModel) {
			if (errorModel.existError) {
				return;
			}
			if (complete) {
				complete();
			}
			[HTAlert title:@"预约成功"];
		}];
    }];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.ht_w, self.view.ht_h - 49)];
		_tableView.backgroundColor = [UIColor ht_colorStyle:HTColorStyleCompareBackground];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
        __weak THCourseTeacherDetailController *weakSelf = self;
        [_tableView ht_updateSection:0 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([THTeacherDetailHeaderCell class])
			.modelArray(@[weakSelf.model]);
        }];
        [_tableView ht_updateSection:1 sectionMakerBlock:^(HTTableViewSectionMaker *sectionMaker) {
            sectionMaker.cellClass([THTeacherDetailInfoCell class])
			.modelArray(@[weakSelf.model]);
        }];
	}
	return _tableView;
}

- (THTableButton *)inviteButton {
	if (!_inviteButton) {
		_inviteButton = [[THTableButton alloc] initWithFrame:CGRectMake(0, self.view.ht_h - 49, self.view.ht_w, 49)];
		[_inviteButton setTitle:@"预约课程" forState:UIControlStateNormal];
        __weak THCourseTeacherDetailController *weakSelf = self;
		[_inviteButton ht_whenTap:^(UIView *view) {
            [weakSelf.class invideButtonTeapedWithModel:weakSelf.model complete:^{
				NSString *identifier = [NSString stringWithFormat:@"%@%@", NSStringFromClass(weakSelf.class), weakSelf.model.teacherId];
				[HTRandomNumberManager ht_randomAppendWithIdentifier:identifier appendCount:1];
				weakSelf.model.joinTimes ++;
				[weakSelf.cell setModel:weakSelf.model row:0];
			}];
		}];
	}
	return _inviteButton;
}

@end
