require 'optparse'

class OptSimple
  attr_accessor :remain

  def initialize(spec, argv)
    parser = OptionParser.new
    spec.each do |s|
      s = [s] unless s.kind_of? Array

      main_option_name, *option_names = s[0..1].select {|o| /^-/ =~ o }.
        map {|o| o.split[0].gsub(/^(\-)+/, '').gsub('-', '_') }

      # regist parser
      parser.on(*s){|v|
        instance_variable_set('@' + main_option_name, v)
      }

      # define getter
      self.class.__send__(
        :attr_reader, main_option_name.to_sym)

      # define getter alias
      option_names.each do |s|
        self.class.__send__(
          :alias_method, s, main_option_name)
      end
    end
    @remain = parser.parse(argv)
  end
end
