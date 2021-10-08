#
#  Be sure to run `pod spec lint CollectionUI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "CollectionUI"
  spec.version      = "1.0.0"
  spec.summary      = "CollectionUI: That is some useful wedigt for UITableView and UICollectionView"
  spec.description  = <<-DESC
    Hello There~
     We need to coding easy!
     We provide UITableView and UICollectionView's useful classes
     And there may take more easy
                   DESC

  spec.homepage     = "https://github.com/MrDeveloperLiu/PirvateRepository.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  # spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "刘杨" => "164182408@qq.com" }
  # Or just: spec.author    = "刘杨"
  # spec.authors            = { "刘杨" => "164182408@qq.com" }
  # spec.social_media_url   = "https://twitter.com/刘杨"

  spec.platform     = :ios, "10.0"
  spec.swift_versions = ['5.0']

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  # spec.source       = { :git => "https://github.com/MrDeveloperLiu/PirvateRepository.git", :tag => "#{spec.version}" }
  spec.source       = { :git => "git@github.com:MrDeveloperLiu/PirvateRepository.git", :tag => "#{spec.version}" }

  spec.source_files  = "CollectionUI/Classes/**/*.swift"
  spec.exclude_files = "CollectionUI/Classes/Exclude"
  # spec.public_header_files = "CollectionUI/Classes/**/*.swift"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
