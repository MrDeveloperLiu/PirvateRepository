#
#  Be sure to run `pod spec lint CollectionUI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "CollectionUI"
  spec.version      = "1.0.5"
  spec.summary      = "CollectionUI: That is some useful wedigt for UITableView and UICollectionView"
  spec.description  = <<-DESC
    Hello There~
     We need to coding easy!
     We provide UITableView and UICollectionView's useful classes
     And there may take more easy
                   DESC

  spec.homepage     = "https://github.com/MrDeveloperLiu/PirvateRepository.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "刘杨" => "164182408@qq.com" }
  spec.platform     = :ios, "10.0"
  spec.swift_versions = ['5.0']

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/MrDeveloperLiu/PirvateRepository.git", :tag => "#{spec.version}" }
  spec.source_files  = "CollectionUI/Classes/**/*"
  spec.exclude_files = "CollectionUI/Classes/Exclude"
  spec.requires_arc = true
  
end
