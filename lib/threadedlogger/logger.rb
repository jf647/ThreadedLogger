# Monkey patch Logger to supress the "Logfile created at" header line
class Logger
  # Monkey patch Logger to supress the "Logfile created at" header line
  class LogDevice
    private

      def add_log_header(_file)
      end
  end
end
