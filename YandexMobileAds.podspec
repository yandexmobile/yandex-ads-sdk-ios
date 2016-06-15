Pod::Spec.new do |s|
  s.name = "YandexMobileAds"
  s.version = "2.2.0"
  s.summary = "The Yandex Mobile Ads SDK provides mobile interfaces for Yandex Advertising Network" 

  s.homepage = "https://tech.yandex.ru/mobile-ads/"
  s.license = { :type => 'PROPRIETARY', :file => 'LICENSE.txt' }
  s.authors = { "Andrey Shender" => "ashender@yandex-team.ru", "Kanstantsin Charnukha" => "xardas@yandex-team.ru" }
  s.platform = :ios, '6.0'
  s.source = { :git => "https://github.com/yandexmobile/yandex-ads-sdk-ios.git", :tag=>s.version.to_s}

  s.source_files = 'SDK/YandexMobileAds/**/*.h'
  s.header_mappings_dir = 'SDK/YandexMobileAds'
  s.public_header_files = "SDK/YandexMobileAds/**/*.h"

  s.vendored_library = 'SDK/libYandexMobileAds.a'
  s.libraries = 'xml2'

  s.dependency 'YandexMobileMetrica', '>= 2.4.1', '<= 2.5.0'
  s.frameworks = 'CoreTelephony', 'AdSupport'
  s.weak_frameworks = 'SafariServices'

  s.requires_arc = true
end
