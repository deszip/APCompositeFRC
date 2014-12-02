//
//  AVMContactsFRC.m
//  Avaamo
//
//  Created by Deszip on 30/09/14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "AVMCompositeFRC.h"

typedef NS_ENUM(NSInteger, AVMCompositeFRCType) {
    AVMCompositeFRCTypeAll = 0,
    AVMCompositeFRCTypeCompany = 1,
};

@interface AVMCompositeFRC () <NSFetchedResultsControllerDelegate> {
    
}

@property (strong, nonatomic) NSArray *controllersCollection;

/**
 *  Converting external section index into controller index by iterating internal controllers.
 *
 *  @param sectionIndex NSInteger representing overall section index
 *
 *  @return NSInteger index of FRC in controllersCollection array
 */
- (NSInteger)controllerIndexForSectionIndex:(NSInteger)sectionIndex;

/**
 *  Converting external section index to a internal FRC section index which could be used to access objects inside FRC
 *
 *  @param externalSectionIndex NSInteger representing section index in overall count
 *
 *  @return NSInteger representin section index relative to its FRC
 */
- (NSInteger)internalSectionIndexForExternalSection:(NSInteger)externalSectionIndex;

@end

@implementation AVMCompositeFRC

- (instancetype)initWithFRCs:(NSArray *)FRCs
{
    self = [super init];
    if (self) {
        _controllersCollection = FRCs;
        for (NSFetchedResultsController *nextController in _controllersCollection) {
            [nextController setDelegate:self];
        }
    }
    
    return self;
}

#pragma mark - NSFetchedResultsController convinience methods

- (NSArray *)fetchedObjects
{
    NSMutableArray *allObjects = [NSMutableArray array];
    for (NSFetchedResultsController *nextController in self.controllersCollection) {
        [allObjects addObjectsFromArray:nextController.fetchedObjects];
    }
    
    return [allObjects copy];
}

- (BOOL)performFetch:(out NSError **)error
{
    NSMutableArray *underlyingErrors = [NSMutableArray array];
    BOOL fetchStatus = YES;
    
    for (NSFetchedResultsController *nextController in self.controllersCollection) {
        NSError *fetchError = nil;
        if (![nextController performFetch:&fetchError]) {
            [underlyingErrors addObject:fetchError];
            fetchStatus = NO;
        }
    }
    
    if (!fetchStatus) {
        *error = [NSError errorWithDomain:AVMCompositeFRCErrorDomain code:0 userInfo:@{AVMCompositeFRCInternalErrorsKey : underlyingErrors}];
    }
    
    return fetchStatus;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger controllerIndex = [self controllerIndexForSectionIndex:indexPath.section];
    if (controllerIndex == NSNotFound || !indexPath) {
        return nil;
    }
    
    NSFetchedResultsController *controller = self.controllersCollection[controllerIndex];
    NSInteger sectionIndex = [self internalSectionIndexForExternalSection:indexPath.section];
    id object = [controller objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:sectionIndex]];
    
    return object;
}

- (NSArray *)sections
{
    NSMutableArray *allSections = [NSMutableArray array];
    
    for (NSFetchedResultsController *nextController in self.controllersCollection) {
        if (nextController.sections.count > 0) {
            [allSections addObjectsFromArray:nextController.sections];
        }
    }
    
    return  [allSections copy];
}

#pragma mark - Tools

- (NSInteger)controllerIndexForSectionIndex:(NSInteger)sectionIndex
{
    NSUInteger sectionsCount = 0;
    for (NSUInteger controllerIndex = 0; controllerIndex < self.controllersCollection.count; controllerIndex++) {
        NSFetchedResultsController *controller = self.controllersCollection[controllerIndex];
        sectionsCount += controller.sections.count;
        
        if (sectionsCount >= sectionIndex + 1) {
            return controllerIndex;
        }
    }
    
    return NSNotFound;
}

- (NSInteger)internalSectionIndexForExternalSection:(NSInteger)externalSectionIndex
{
    NSInteger sectionsCount = 0;
    NSInteger controllerIndex = [self controllerIndexForSectionIndex:externalSectionIndex];
    for (NSInteger i = 0; i < controllerIndex; i++) {
        NSFetchedResultsController *nextController = self.controllersCollection[i];
        sectionsCount += nextController.sections.count;
    }
    
    NSInteger internalSectionIndex = externalSectionIndex - sectionsCount;
    
    return internalSectionIndex;
}

#pragma mark - 
#pragma mark - Protocols implementations
#pragma mark - 

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]) {
        [self.delegate controllerWillChangeContent:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)]) {
        [self.delegate controller:self didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate controller:self didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]) {
        [self.delegate controllerDidChangeContent:self];
    }
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:sectionIndexTitleForSectionName:)]) {
        return [self.delegate controller:self sectionIndexTitleForSectionName:sectionName];
    }
    
    return nil;
}

@end
