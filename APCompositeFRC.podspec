Pod::Spec.new do |s|
  s.name             = "APCompositeFRC"
  s.version          = "0.1.0"
  s.summary          = "A wrapper for NSFetchedResultsControllers collection."
  s.description      = <<-DESC
                       Wrapper which allows to interact with collection of NSFetchedResultsController instances as one.
                       Mimics same API NSFetchedResultsController is providing.
                       DESC
  s.homepage         = "https://github.com/deszip/APCompositeFRC"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Deszip" => "igor@alterplay.com" }
  s.source           = { :git => "https://github.com/deszip/APCompositeFRC.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'APCompositeFRC' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'CoreData'
end
