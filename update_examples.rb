#!/usr/bin/env ruby

class ExamplesUpdater
    def self.update
        workdir = File.expand_path(File.dirname(__FILE__))
        exapmples_path = File.join(workdir, "Examples")
        Dir.glob("#{exapmples_path}/*").each do |entry|
            if File.directory?(entry)
                puts "\n\n>>Updating " + entry
                Dir.chdir(entry) { puts `pod update` }
            end
        end
    end
end

if __FILE__ == $0
    ExamplesUpdater.update
end
