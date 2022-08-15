require 'mkmf'
require 'open-uri'
require 'rbconfig'
require 'open3'

ROOT = File.expand_path('../..', __dir__)
WORKDIR = Dir.pwd
KAKASI_URL = 'https://github.com/iliabylich/kanji_to_katakana/releases/download/kakasi-2.3.6/kakasi-2.3.6.tar.gz'

$stderr.puts "ROOT = #{ROOT}"
$stderr.puts "Dir.pwd = #{Dir.pwd}"

def sh(cmd, env: {})
  $stderr.puts "Running #{cmd}"
  stdout, stderr, status = Open3.capture3(env, cmd)

  unless status.success?
    $stderr.puts 'Command failed'
    $stderr.puts "[stdout]\n#{stdout}"
    $stderr.puts "[stderr]\n#{stderr}"
    exit 1
  end

  puts stdout
end

# Compute the platform
case RbConfig::CONFIG['build_cpu']
when 'aarch64', 'x86_64'
  build_cpu = RbConfig::CONFIG['build_cpu']
else
  raise "Unsupported build_cpu #{RbConfig::CONFIG['build_cpu']}"
end

linux = darwin = false
case RbConfig::CONFIG['build_os']
when /darwin/
  build_os = 'apple-darwin'
  darwin = true
  $DLDFLAGS << ' -liconv'
when 'linux-gnu'
  $CFLAGS << ' -fPIC'
  linux = true
  build_os = 'unknown-linux-gnu'
else
  raise "Unsupported build_os #{RbConfig::CONFIG['build_os']}"
end

ENABLE_ASAN = !ENV['KANJI_TO_KATAKANA_ENABLE_ASAN'].nil?

$CFLAGS << ' -fsanitize=address' if ENABLE_ASAN

platform = "#{build_cpu}-#{build_os}"
$stderr.puts "PLATFORM = #{platform}"
sh('uname -a')

# Install autoconf
def has_executable?(name)
  system("which #{name}")
  $?.success?
end

if has_executable?('autoconf')
  $stderr.puts 'Found pre-installed autoconf'
elsif has_executable?('apt')
  $stderr.puts 'Found apt'
  sh('sudo apt update && sudo apt install -y autoconf')
elsif has_executable?('yum')
  $stderr.puts 'Found yum'
  sh('sudo yum install autoconf')
else
  raise 'No autoconf/yum/apt, aborting'
end

unless has_executable?('autoconf')
  raise 'No autoconf after installation, aborting'
end

# Download kakasi
Dir.chdir(ROOT) do
  $stderr.puts 'Downloading Kakasi'
  URI.open(KAKASI_URL) do |content|
    File.binwrite('kakasi-2.3.6.tar.gz', content.read)
  end

  sh('tar -xf kakasi-2.3.6.tar.gz')
  Dir.chdir(File.join(ROOT, 'kakasi-2.3.6')) do
    # apply a patch
    sh('patch -p1 < ../0001-fix-configure-with-the-latest-iconv.patch')
    sh('rm configure')
    sh('autoconf')
    kakasi_cflags = []
    kakasi_cflags << '-fPIC' if linux
    kakasi_cflags << '-g'
    kakasi_cflags << '-fsanitize=address' if ENABLE_ASAN

    begin
      sh('./configure --prefix=$PWD/local', env: { 'CFLAGS' => kakasi_cflags.join(' ') })
    ensure
      sh('cat config.log')
    end

    # build
    sh('make')
    sh('make install')

    # copy header
    sh('cp local/include/libkakasi.h ..')

    # copy library
    sh('cp local/lib/libkakasi.a ..')

    # copy dictionaries
    sh('cp local/share/kakasi/itaijidict ../lib/kanji_to_katakana/itaijidict')
    sh('cp local/share/kakasi/kanwadict ../lib/kanji_to_katakana/kanwadict')
  end

  # and remove all artifacts
  sh('rm -r kakasi-2.3.6') unless ENABLE_ASAN
  sh('rm kakasi-2.3.6.tar.gz')
end

# DO NOT LINK WITH libruby DYLIB
# Removing this line will make compiled dylib non-portable
$LIBRUBYARG = nil

$CFLAGS << " -I#{ROOT}"
$LOCAL_LIBS << "#{ROOT}/libkakasi.a"

# Create a platform.rb file
File.write(
  File.join(ROOT, 'lib/kanji_to_katakana/platform.rb'),
  "KanjiToKatakana::PLATFORM = '#{platform}'\n"
)

create_makefile 'kanji_to_katakana'

makefile = File.read('Makefile')
makefile.gsub!('V = 0', 'V = 1')
File.write('Makefile', makefile)
