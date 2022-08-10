# frozen_string_literal: true

require 'English'
require 'rbconfig'

*src, output = ARGV

def link_dir(dir)
  "-L#{dir}"
end

cc = RbConfig::CONFIG['LDSHARED'].split.first
cc_override = ENV['CC'] || cc

script = [
  RbConfig::CONFIG['LDSHARED'].gsub(cc, cc_override),
  "-o #{output}",
  *src,

  ENV['LDFLAGS'] || '',

  link_dir(RbConfig::CONFIG['libdir']),
  RbConfig::CONFIG['LDFLAGS'],
  RbConfig::CONFIG['DLDFLAGS'],

  RbConfig::CONFIG['LIBS']
].join(' ')

if ENV['DRY_RUN']
  puts script
else
  puts script if ENV['V']
  system(script)
  exit $CHILD_STATUS.exitstatus
end
