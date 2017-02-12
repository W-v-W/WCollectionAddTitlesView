
Pod::Spec.new do |s|


  s.name         = "WCollectionAddTitlesView"
  s.version      = "0.0.1"
  s.summary      = "A collection view interact with titles in scroll view."

  s.description  = <<-DESC
  A collection view interact with titles in scroll view.
  You can add your content view in collection cell.
                   DESC

  s.homepage     = "https://github.com/W-v-W/WCollectionAddTitlesView"


  s.license      = { :type => "MIT", :file => "LICENSE" }



  s.author    = "wz"


  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/W-v-W/WCollectionAddTitlesView.git", :tag => "#{s.version}" }


  s.source_files  = "WCollectionAddTitlesView/Classes/**/*.{h,m}"


  s.frameworks = "Foundation", "UIKit"



end
