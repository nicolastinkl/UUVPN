Pod::Spec.new do |spec|
  spec.name                = "Crisp"
  spec.version             = "2.6.0"
  spec.summary             = "Crisp SDK for iOS."
  spec.description         = "Crisp SDK for iOS, used for visitors to get help from operators."
  spec.homepage            = "https://crisp.chat"
  spec.author              = "Crisp IM SAS"
  spec.platform            = :ios, "13.0"
  spec.license             = { :type => "Commercial" }
  spec.source              = { :http => "https://github.com/crisp-im/crisp-sdk-ios/releases/download/2.6.0/Crisp_cocoapods_2.6.0.zip" }
  
  spec.default_subspecs    = "Crisp"
  
  spec.subspec "Crisp" do |s|
    s.vendored_frameworks  = "Crisp.xcframework"
    s.preserve_paths       = "Crisp.xcframework"
  end
  
  spec.subspec "CrispWebRTC" do |s|
    s.vendored_frameworks  = "CrispWebRTC.xcframework"
    s.preserve_paths       = "CrispWebRTC.xcframework"
    
    s.dependency "Crisp/WebRTC"
  end
  
  spec.subspec "WebRTC" do |s|
    s.vendored_frameworks  = "WebRTC.xcframework"
    s.preserve_paths       = "WebRTC.xcframework"
  end
end
