Pod::Spec.new do |s|

  s.name         = "CoreArchitecture"
  s.version      = "0.0.1"
  s.summary      = "Starter kit for Core architecture."
  s.description  = <<-DESC
                    Core helps you design applications in a way that the app
                    flow is driven by business layer, instead of UI layer. It
                    also promotes unidirectional data flow between components
                    for consistency, high testability and powerful debugging.
                   DESC
  s.homepage     = "https://github.com/gokselkoksal/Core/"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author           = { "Göksel Köksal" => "gokselkoksal@gmail.com" }
  s.social_media_url = "https://twitter.com/gokselkk"
  
  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  s.source       = { :git => "https://github.com/gokselkoksal/Core.git", :tag => "#{s.version}" }
  s.source_files = "Core/Sources", "Core/Sources/**/*.swift"

end
