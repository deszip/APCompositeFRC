//
//  AVMContactsFRC.h
//  Avaamo
//
//  Created by Deszip on 30/09/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString * const AVMCompositeFRCErrorDomain = @"AVMCompositeFRCErrorDomain";
static NSString * const AVMCompositeFRCInternalErrorsKey = @"AVMCompositeFRCInternalErrorsKey";

@protocol AVMCompositeFRCDelegate;

@interface AVMCompositeFRC : NSObject {

}

/**
 *  If set to YES FRC will skip sections with zero objects in it
 */
@property (assign, nonatomic) BOOL showEmptySections;

@property (weak, nonatomic) id <AVMCompositeFRCDelegate> delegate;

/**
 *  Designated initializer
 *
 *  @param FRCs NSArray of FRCs to be used as source.
 *
 *  @return AVMCompositeFRC instance. Internal FRCs are not fetched.
 */
- (instancetype)initWithFRCs:(NSArray *)FRCs;

/**
 *  Wrapper for fetchedObjects method on FRC
 *
 *  @return NSArray containing all objects from internal FRCs.
 */
- (NSArray *)fetchedObjects;

/**
 *  Wrapper for performFetch method on FRC
 *
 *  @param error NSError pointer which will be populated with fetch fail reasons. For error for each internal FRC see AVMCompositeFRCInternalErrorsKey key in userInfo
 *
 *  @return BOOL indicating fetch success. No if at least one of internal FRCs failed to fetch.
 */
- (BOOL)performFetch:(out NSError **)error;

/**
 *  Wrapper for objetAtIndexPath method on FRC
 *
 *  @param indexPath index path to fetch object for
 *
 *  @return id object from corresponding internal FRC. Index path will be traversed to find correct internal controller.
 *
 *  @see - (NSInteger)controllerIndexForSectionIndex:(NSInteger)sectionIndex
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Wrapper for sections method on FRC
 *
 *  @return NSArray containing all sections from internal FRCs.
 */
- (NSArray *)sections;

@end

/**
 *  Facade protocol for FRC users. Mimics NSFetchedResultsController delegate API.
 */
@protocol AVMCompositeFRCDelegate <NSObject>

@optional
- (void)controllerWillChangeContent:(AVMCompositeFRC *)controller;
- (void)controller:(AVMCompositeFRC *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type;
- (void)controller:(AVMCompositeFRC *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controllerDidChangeContent:(AVMCompositeFRC *)controller;
- (NSString *)controller:(AVMCompositeFRC *)controller sectionIndexTitleForSectionName:(NSString *)sectionName;

@end
