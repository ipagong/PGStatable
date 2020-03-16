#
# Be sure to run `pod lib lint PGStatable.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PGStatable'
  s.version          = '0.2.0'
  s.summary          = 'State with protocols'
  s.description      = 'Container with State that simple protocols.'

  s.homepage         = 'https://github.com/ipagong/PGStatable'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'suwan.park' => 'ipagong.dev@gmail.com' }
  s.source           = { :git => 'https://github.com/ipagong/PGStatable.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version         = '5.0'

  s.source_files = 'PGStatable/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PGStatable' => ['PGStatable/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
