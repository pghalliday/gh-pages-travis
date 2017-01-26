# coding: utf-8
require 'json'

Gem::Specification.new do |spec|
  package = JSON.load File.new('package.json')

  spec.name          = package['name']
  spec.version       = package['version']
  spec.authors       = package['author']
  spec.summary       = package['description']
  spec.description   = package['description']
  spec.homepage      = package['homepage']
  spec.license       = package['license']
  spec.files         << package['bin']
  spec.executables   << package['name']
end
