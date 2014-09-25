require "gitgit/version"
require "thor"
require "git"

module Gitgit
  # Your code goes here...
  class CLI < Thor
    include Thor::Actions

    desc "init", "Initialise a git repo"
    def init
      Git.init
      say "Git repo created! Let's git going ...", :green
    end

    desc "save", "Save you changes to the repo"
    def save
      begin
        g = Git.open('.')
      rescue ArgumentError
        say "This folder isn't git enabled. Check you're in the right folder!", :red
        say ""
        say "You're currently in the folder #{Dir.pwd}."
        say ""
        say "If this is the right folder you need to create a repository first:"
        say ""
        say "      gitgit init"
        say ""
        say "If not, use cd to move to the right folder."
        return
      end
      say "You're about to save the following changes:"
      say ""
      say "New files:"
      new_files = g.status.added.merge(g.status.untracked)
      new_files.each do |k, v|
        say "     #{k}", :green
      end
      say "     none" if new_files.length == 0
      say ""
      say "Changed files:"
      g.status.changed.each do |k, v|
        say "     #{k}", :yellow
      end
      say "     none" if g.status.changed.length == 0
      say ""
      say "Deleted files:"
      g.status.deleted.each do |k, v|
        say "     #{k}", :red
      end
      say "     none" if g.status.deleted.length == 0
      say ""
      return unless yes? "Do you want to save these changes to git? (y/n)"
      m = ask "Give a short description of the work you're saving: "
      g.add(all:true)
      g.commit(m)
    end

    desc "lg", "Show your recent saves"
    def lg
      g = Git.open('.')
      g.log(20).each {|l| puts l }
    end

  end
end
