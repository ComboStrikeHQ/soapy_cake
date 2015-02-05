require 'nokogiri'
require 'saxerator'
require 'httparty'
require 'active_support/core_ext/date'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/zones'

require 'soapy_cake/version'
require 'soapy_cake/helper'
require 'soapy_cake/error'
require 'soapy_cake/request'
require 'soapy_cake/response'
require 'soapy_cake/client'
require 'soapy_cake/admin'
require 'soapy_cake/affiliate'

module SoapyCake
  API_VERSIONS = YAML.load(File.read(File.expand_path('../../api_versions.yml', __FILE__)))
end
