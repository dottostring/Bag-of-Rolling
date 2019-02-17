Pod::Spec.new do |s|
  s.name         = "Bag-of-Rolling"
  s.swift_version = '4.2'
  s.version      = "1.8"
  s.summary      = "An RPG Dice Rolling Framework."
  s.description  = "To make it easy to roll dice with modifiers for RPG systems"
  s.homepage     = "https://github.com/dottostring/Bag-of-Rolling"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Adam Hitt" => "droppingjake1@gmail.com" }
  s.source       = { :git => "https://github.com/dottostring/Bag-of-Rolling.git", :tag => "#{s.version}" }
  s.source_files  = 'Bag-of-Rolling', 'Bag-of-Rolling/**/*.{h,m,swift}'
end
