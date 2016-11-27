#
# Be sure to run `pod lib lint PGImageCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PGImageCarousel'
  s.version          = '0.3.0'
  s.summary          = 'A scrollable ImageCarousel with page indicator'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This CocoaPod provides a flexible and reusable scrollable ImageCarousel 
UIComponent that can be initialized with an array of images. Features 
include page indicator and different grid sizes.
                       DESC

  s.homepage         = 'https://github.com/peygar/PGImageCarousel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peyman Gardideh' => 'peyman+github@halfmoon.ws' }
  s.source           = { :git => 'https://github.com/peygar/PGImageCarousel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PGImageCarousel/Classes/**/*'
  
  s.resource_bundles = {
    'PGImageCarousel' => [
      'PGImageCarousel/Classes/*.xib'
    ]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
