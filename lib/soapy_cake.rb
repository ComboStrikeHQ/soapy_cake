# frozen_string_literal: true
require 'yaml'
require 'logger'
require 'nokogiri'
require 'saxerator'
require 'retryable'
require 'active_support/core_ext/hash/reverse_merge'
require 'active_support/core_ext/hash/transform_values'
require 'active_support/time'

require 'soapy_cake/version'
require 'soapy_cake/const'
require 'soapy_cake/helper'
require 'soapy_cake/error'
require 'soapy_cake/time_converter'
require 'soapy_cake/request'
require 'soapy_cake/response'
require 'soapy_cake/response_value'
require 'soapy_cake/client'
require 'soapy_cake/admin'
require 'soapy_cake/admin_batched'
require 'soapy_cake/admin_addedit'
require 'soapy_cake/admin_track'
require 'soapy_cake/affiliate'

require 'soapy_cake/modification_type'
require 'soapy_cake/campaigns'

module SoapyCake
  API_CONFIG = YAML.load(File.read(File.expand_path('../../api.yml', __FILE__)))
  NET_TIMEOUT = 600
end
