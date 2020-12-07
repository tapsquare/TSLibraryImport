Pod::Spec.new do |s|
  s.name             = "TSLibraryImport"
  s.version          = "0.0.2"
  s.summary          = "Objective-C class for importing files from user's iPod Library in iOS4."
  s.homepage         = "https://github.com/blissapps/TSLibraryImport"
  s.license          = 'MIT'
  s.author           = { "tapsquare, llc." => "art@tapsquare.com" }
  s.source           = { :git => "https://github.com/blissapps/TSLibraryImport.git", :tag => s.version.to_s }

  s.requires_arc          = false

  s.ios.deployment_target = '10.0'

  s.source_files          = 'Classes/TSLibraryImport.{h,m}'
end