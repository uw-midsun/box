module Which

  # which returns the pathnames of the files (or links) which would be
  # executed in the current environment, had its arguments been given as
  # commands in the shell by searching in the $PATH
  def self.which(cmd)
    w = Which.new
    w.which0(cmd) do |abs_exe|
      return abs_exe
    end
    nil
  end

  # which_all returns all matching pathnames of the files that are in the $PATH
  # similar to which -a
  def self.which_all(cmd)
    w = Which.new
    results = []
    w.which0(cmd) do |abs_exe|
      results << abs_exe
    end
    results
  end

  class Which
    def executable_program?(file)
      # directories can be executable, so we exclude them
      File.executable?(file) && !File.directory?(file)
    end

    def find_executables(path, cmd, &_block)
      executable_path_extensions.each do |ext|
        if executable_program?(abs_path = File.expand_path(cmd + ext, path))
          yield(abs_path)
        end
      end
    end

    def executable_path_extensions
      # $PATHEXT is used on Windows to determine valid file extensions
      ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    end

    def search_paths
      ENV['PATH'].split(File::PATH_SEPARATOR)
    end

    def which0(cmd, &found_exe)
      find_executables(nil, cmd, &found_exe) if File.basename(cmd) != cmd

      search_paths.each do |path|
        find_executables(path, cmd, &found_exe)
      end
    end
  end

end
