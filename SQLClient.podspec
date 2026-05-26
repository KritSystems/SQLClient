Pod::Spec.new do |s|
  s.name     = 'SQLClient'
  s.version  = '1.0.0-kritsystems'
  s.license  = 'MIT'
  s.summary  = 'An Objective-C wrapper around the open-source FreeTDS library (KritSystems fork with libsybdb XCFramework)'
  s.homepage = 'https://github.com/KritSystems/SQLClient'
  s.authors  = { 'Martin Rybak' => 'martin.rybak@gmail.com' }
  s.source   = { :git => 'https://github.com/KritSystems/SQLClient.git', :tag => s.version.to_s }
  s.source_files = 'SQLClient/SQLClient/SQLClient/*.{h,m}'
  s.vendored_frameworks = 'SQLClient/SQLClient/SQLClient/libsybdb.xcframework'
  s.libraries = 'iconv'
  s.requires_arc = true
  s.ios.deployment_target = '15.0'
end
