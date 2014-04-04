require 'active_support/core_ext/string'
require 'soapy_cake/version'
require 'soapy_cake/client'

module SoapyCake
  API_VERSIONS = YAML.load(File.read(File.expand_path('../../api_versions.yml', __FILE__)))
end
