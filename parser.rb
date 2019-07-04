require_relative 'lib/SmartPensionParser'

log_parser = SmartPensionParser.new(ARGV[0])
log_parser.parse_log

log_parser.total_views
log_parser.unique_page_views

