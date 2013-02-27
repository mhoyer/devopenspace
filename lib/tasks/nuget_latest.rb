class NuGetLatest
  attr_reader :path

  def initialize(package_name, packages_dir = Dir.pwd)
    @package_name = package_name

    raise "#{packages_dir} is not a directory" unless File.directory? packages_dir

    Dir.chdir packages_dir do
      candidates = Dir["#{package_name}*"]
      raise "No package '#{package_name}' was found in #{packages_dir}" unless candidates.any?

      latest = find_latest_version candidates
      @path = File.join packages_dir, latest
    end
  end

  def to_s
    @path
  end

  def +(other)
    to_s + other
  end

  private
  def find_latest_version(candidates)
    return candidates.first if candidates.length == 1

    latest = candidates.map { |path|
      version = path.sub /^#{@package_name}./, ''
      version = parse_version version

      {
        :version => version,
        :path => path
      }
    }.max { |left, right| left[:version] <=> right[:version] }

    latest[:path]
  end

  def parse_version(version_string)
    major, minor, patch, revision, special = version_string.match(/^(\d+)\.(\d+)\.(\d+)\.?(\d+)?-?(.+)?$/).captures
    SemVer.new(major.to_i, minor.to_i, patch.to_i, revision.to_i, special)
  end

  # Borrowed from the SemVer gem and enhanced to support .NET's 4-digit versioning system.
  class SemVer
    attr_accessor :major, :minor, :patch, :revision, :special

    def initialize(major = 0, minor = 0, patch = 0, revision = 0, special = '')
      major.kind_of? Integer or raise "invalid major: #{major}"
      minor.kind_of? Integer or raise "invalid minor: #{minor}"
      patch.kind_of? Integer or raise "invalid patch: #{patch}"
      revision.kind_of? Integer or raise "invalid revision: #{revision}"

      unless special.nil? or special.empty?
        special =~ /[A-Za-z][0-9A-Za-z-]+/ or raise "invalid special: #{special}"
      end

      @major, @minor, @patch, @revision, @special = major, minor, patch, revision, special
    end

    def <=>(other)
      maj = @major.to_i <=> other.major.to_i
      return maj unless maj == 0

      min = @minor.to_i <=> other.minor.to_i
      return min unless min == 0

      pat = @patch.to_i <=> other.patch.to_i
      return pat unless pat == 0

      rev = @revision.to_i <=> other.revision.to_i
      return rev unless rev == 0

      spe = @special <=> other.special
      return spe unless spe == 0

      0
    end

    include Comparable
  end
end

module Conversions
  def NuGetLatest(package_name, packages_dir)
    NuGetLatest.new(package_name, packages_dir)
  end
end

include Conversions
