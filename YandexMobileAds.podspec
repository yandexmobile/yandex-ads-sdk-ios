Pod::Spec.new do |s|
  s.name = "YandexMobileAds"
  s.version = "2.0.0-beta1"
  s.summary = "The Yandex Mobile Ads SDK provides mobile interfaces for Yandex Advertising Network" 

  s.homepage = "https://partner.yandex.ru/"
  s.license = { :type => 'PROPRIETARY', :file => 'LICENSE.txt' }
  s.authors = { "Andrey Shender" => "ashender@yandex-team.ru", "Kanstantsin Charnukha" => "xardas@yandex-team.ru" }
  s.platform = :ios, '6.0'
  s.source = { :git => "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", :tag=>s.version.to_s}

  s.source_files = 'YandexMobileAds/**/*.h'
  s.header_mappings_dir = 'YandexMobileAds'
  s.public_header_files = "YandexMobileAds/**/*.h"

  s.vendored_library = 'libYandexMobileAds.a'
  s.libraries = 'xml2'

  s.dependency 'YandexMobileMetrica', '>= 2.0.0', '<= 2.1.1'
  s.frameworks = 'CoreTelephony', 'AdSupport'
  s.weak_frameworks = 'SafariServices'

  s.requires_arc = true
end
