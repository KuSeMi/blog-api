# frozen_string_literal: true

require 'oj'

Blueprinter.configure do |config|
  config.generator = Oj
  config.sort_fields_by = :definition
end
