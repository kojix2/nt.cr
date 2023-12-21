require "notify"
require "option_parser"
require "gettext"
require "./nt/version"

Gettext.setlocale(Gettext::LC::ALL, "")
Gettext.bindtextdomain("com.kojix2.nt", {{env("NT_LOCALE_LOCATION").nil? ? "/usr/share/locale" : env("NT_LOCALE_LOCATION")}})
Gettext.textdomain("com.kojix2.nt")

OptionParser.parse do |parser|
  parser.banner = "Usage: nt <command>"
  parser.on("-h", "--help", "Show this message") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Show version") do
    puts "nt #{NT::VERSION}"
    exit
  end
end

notifier = Notify.new

command = ARGV.join(" ")

status = nil
elapsed_time = Time.measure do
  status = Process.run(command, shell: true, input: STDIN, output: STDOUT, error: STDERR)
end.total_seconds.round(2)

unless status.nil?
  if status.success?
    msg = String.build do |s|
      s << Gettext.gettext("Success")
      s << " #{elapsed_time} "
      s << Gettext.gettext("sec")
    end
    notifier.notify msg, body: command
  else
    msg = String.build do |s|
      s << Gettext.gettext("Failed")
      s << " #{elapsed_time} "
      s << Gettext.gettext("sec")
    end
    notifier.notify msg, body: command
  end
end
