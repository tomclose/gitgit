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
      yes? "Do you really want to save?"
      m = ask "Give a short description of the work you're saving: "
      g = Git.open('.')
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
