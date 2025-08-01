MLN_IOS_SDK_HEADERS = [
    "src/MLNAnnotationImage.h",
    "src/MLNAnnotationView.h",
    "src/MLNCalloutView.h",
    "src/MLNCameraChangeReason.h",
    "src/MLNCompassButton.h",
    "src/MLNMapProjection.h",
    "src/MLNMapView+IBAdditions.h",
    "src/MLNMapViewDelegate.h",
    "src/MLNMapView.h",
    "src/MLNUserLocation.h",
    "src/MLNUserLocationAnnotationView.h",
    "src/MLNUserLocationAnnotationViewStyle.h",
    "src/MLNScaleBar.h"
]

MLN_IOS_PUBLIC_HEADERS = [
    "src/Mapbox.h",
]

MLN_IOS_PRIVATE_HEADERS = [
    "src/NSOrthography+MLNAdditions.h",
    "src/UIDevice+MLNAdditions.h",
    "src/UIImage+MLNAdditions.h",
    "src/MLNUserLocationHeadingArrowLayer.h",
    "src/MLNUserLocationHeadingIndicator.h",
    "src/UIColor+MLNAdditions.h",
    "src/MLNMapAccessibilityElement.h",
    "src/UIViewController+MLNAdditions.h",
    "src/UIView+MLNAdditions.h",
    "src/MLNFaux3DUserLocationAnnotationView.h",
    "src/MLNUserLocationHeadingBeamLayer.h",
    "src/MLNAnnotationContainerView.h",
    "src/MLNAnnotationContainerView_Private.h",
    "src/MLNAnnotationImage_Private.h",
    "src/MLNAnnotationView_Private.h",
    "src/MLNCompassButton_Private.h",
    "src/MLNMapView_Private.h",
    "src/MLNUserLocationAnnotationView_Private.h",
    "src/MLNUserLocation_Private.h",
    "src/MLNCompactCalloutView.h",
    "src/MLNMapView+Impl.h",
    "src/MLNMapView+Metal.h",
    "src/MLNMapView+OpenGL.h",
]

MLN_IOS_PUBLIC_OBJC_SOURCE = [
    "src/MLNAnnotationContainerView.m",
    "src/MLNAnnotationImage.m",
    "src/MLNCompactCalloutView.m",
    "src/MLNUserLocation.m",
    "src/MLNUserLocationAnnotationView.m",
    "src/MLNUserLocationAnnotationViewStyle.m",
    "src/MLNUserLocationHeadingArrowLayer.m",
    "src/MLNUserLocationHeadingBeamLayer.m",
    "src/NSOrthography+MLNAdditions.m",
    "src/UIDevice+MLNAdditions.m",
    "src/UIView+MLNAdditions.m",
    "src/UIViewController+MLNAdditions.m",
]

MLN_IOS_PUBLIC_OBJCPP_SOURCE = [
    "src/MLNAnnotationView.mm",
    "src/MLNCompassButton.mm",
    "src/MLNFaux3DUserLocationAnnotationView.mm",
    "src/MLNMapAccessibilityElement.mm",
    "src/MLNMapProjection.mm",
    "src/MLNMapView.mm",
    "src/MLNMapView+Impl.mm",
    "src/MLNScaleBar.mm",
    "src/UIColor+MLNAdditions.mm",
    "src/UIImage+MLNAdditions.mm",
]
MLN_IOS_PUBLIC_OBJCPP_OPENGL_SOURCE = [
    "src/MLNMapView+OpenGL.mm",
]
MLN_IOS_PUBLIC_OBJCPP_METAL_SOURCE = [
    "src/MLNMapView+Metal.mm",
]

MLN_PUBLIC_IOS_APP_SOURCE = [
    "app/MBXAnnotationView.m",
    "app/MBXAppDelegate.m",
    "app/MBXCustomCalloutView.h",
    "app/MBXCustomCalloutView.m",
    "app/MBXCustomLocationViewController.m",
    "app/MBXEmbeddedMapViewController.m",
    "app/MBXFrameTimeGraphView.m",
    "app/MBXOfflinePacksTableViewController.m",
    "app/MBXOrnamentsViewController.m",
    "app/MBXSnapshotsViewController.m",
    "app/MBXState.m",
    "app/MBXStateManager.m",
    "app/MBXUserLocationAnnotationView.m",
    "app/MBXViewController.mm",
    "app/main.m",
    "app/MBXAnnotationView.h",
    "app/MBXAppDelegate.h",
    "app/MBXCustomLocationViewController.h",
    "app/MBXEmbeddedMapViewController.h",
    "app/MBXFrameTimeGraphView.h",
    "app/MBXOfflinePacksTableViewController.h",
    "app/MBXOrnamentsViewController.h",
    "app/MBXSnapshotsViewController.h",
    "app/MBXState.h",
    "app/MBXStateManager.h",
    "app/MBXUserLocationAnnotationView.h",
    "app/MBXViewController.h",
    "app/MLNMapView_Experimental.h",
]
