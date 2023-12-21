require "notify"
require "option_parser"
require "./nt/version"

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
    notifier.notify "Success #{elapsed_time} sec", body: command
  else
    notifier.notify "Failed #{elapsed_time} sec", body: command
  end
end
