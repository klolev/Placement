//
//  AnyPlacementLayout.swift
//  Placement
//
//  Created by Sam Pettersson on 2022-09-16.
//

import Foundation
import SwiftUI

public struct AnyPlacementLayout: PlacementLayout {
    var _sizeThatFits: (
        _ proposal: PlacementProposedViewSize,
        _ subviews: PlacementLayoutSubviews,
        _ cache: Cache
    ) -> (size: CGSize, cache: Cache)
    
    var _makeCache: (
        _ subviews: PlacementLayoutSubviews
    ) -> Cache
    
    var _updateCache: (
        _ cache: Cache,
        _ subviews: PlacementLayoutSubviews
    ) -> Cache
    
    var _placeSubviews: (
        _ bounds: CGRect,
        _ proposal: PlacementProposedViewSize,
        _ subviews: PlacementLayoutSubviews,
        _ cache: Cache
    ) -> Cache
    
    var _spacing: (
        _ subviews: PlacementLayoutSubviews,
        _ cache: Cache
    ) -> (spacing: PlacementViewSpacing, cache: Cache)
    
    var _explicitAlignmentVertical: (
        _ guide: VerticalAlignment,
        _ bounds: CGRect,
        _ proposal: PlacementProposedViewSize,
        _ subviews: PlacementLayoutSubviews,
        _ cache: Cache
    ) -> (alignment: CGFloat?, cache: Cache)
    
    var _explicitAlignmentHorizontal: (
        _ guide: HorizontalAlignment,
        _ bounds: CGRect,
        _ proposal: PlacementProposedViewSize,
        _ subviews: PlacementLayoutSubviews,
        _ cache: Cache
    ) -> (alignment: CGFloat?, cache: Cache)
    
    var _prefersLayoutProtocol: () -> Bool
    var _disablesAnimationsWhenPlacing: () -> Bool
    
    public func sizeThatFits(proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Any) -> CGSize {
        let sizeThatFitsReturn = _sizeThatFits(proposal, subviews, cache)
        cache = sizeThatFitsReturn.cache
        return sizeThatFitsReturn.size
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: PlacementProposedViewSize, subviews: PlacementLayoutSubviews, cache: inout Any) {
        let placeSubviewsReturn = _placeSubviews(bounds, proposal, subviews, cache)
        cache = placeSubviewsReturn
    }
        
    public func makeCache(subviews: PlacementLayoutSubviews) -> Any {
        _makeCache(subviews)
    }
    
    public func updateCache(_ cache: inout Any, subviews: PlacementLayoutSubviews) {
        let updateCacheReturn = _updateCache(cache, subviews)
        cache = updateCacheReturn
    }
    
    public func spacing(subviews: PlacementLayoutSubviews, cache: inout Any) -> PlacementViewSpacing {
        let spacingReturn = _spacing(subviews, cache)
        cache = spacingReturn.cache
        return spacingReturn.spacing
    }
    
    public var prefersLayoutProtocol: Bool {
        _prefersLayoutProtocol()
    }
    
    public var disablesAnimationsWhenPlacing: Bool {
        _disablesAnimationsWhenPlacing()
    }
    
    public func explicitAlignment(
        of guide: VerticalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Any
    ) -> CGFloat? {
        let explicitAlignmentReturn = _explicitAlignmentVertical(guide, bounds, proposal, subviews, cache)
        cache = explicitAlignmentReturn.cache
        return explicitAlignmentReturn.alignment
    }
    
    public func explicitAlignment(
        of guide: HorizontalAlignment,
        in bounds: CGRect,
        proposal: PlacementProposedViewSize,
        subviews: PlacementLayoutSubviews,
        cache: inout Any
    ) -> CGFloat? {
        let explicitAlignmentReturn = _explicitAlignmentHorizontal(guide, bounds, proposal, subviews, cache)
        cache = explicitAlignmentReturn.cache
        return explicitAlignmentReturn.alignment
    }
        
    public init<L: PlacementLayout>(
        _ layout: L
    ) {
        self._sizeThatFits = { proposal, subviews, cache in
            var cache = cache as! L.Cache
            let size = layout.sizeThatFits(proposal: proposal, subviews: subviews, cache: &cache)
            return (size, cache)
        }
        self._makeCache = { subviews in
            layout.makeCache(subviews: subviews)
        }
        self._placeSubviews = { bounds, proposal, subviews, cache in
            var cache = cache as! L.Cache
            layout.placeSubviews(in: bounds, proposal: proposal, subviews: subviews, cache: &cache)
            return cache
        }
        self._updateCache = { cache, subviews in
            var cache = cache as! L.Cache
            layout.updateCache(&cache, subviews: subviews)
            return cache
        }
        self._spacing = { subviews, cache in
            var cache = cache as! L.Cache
            let spacing = layout.spacing(subviews: subviews, cache: &cache)
            return (spacing, cache)
        }
        self._explicitAlignmentHorizontal = { guide, bounds, proposal, subviews, cache in
            var cache = cache as! L.Cache
            let alignment = layout.explicitAlignment(of: guide, in: bounds, proposal: proposal, subviews: subviews, cache: &cache)
            return (alignment, cache)
        }
        self._explicitAlignmentVertical = { guide, bounds, proposal, subviews, cache in
            var cache = cache as! L.Cache
            let alignment = layout.explicitAlignment(of: guide, in: bounds, proposal: proposal, subviews: subviews, cache: &cache)
            return (alignment, cache)
        }
        self._prefersLayoutProtocol = {
            return layout.prefersLayoutProtocol
        }
        self._disablesAnimationsWhenPlacing = {
            return layout.disablesAnimationsWhenPlacing
        }
    }
}
