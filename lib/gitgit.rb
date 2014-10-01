require "gitgit/version"
require "thor"
require "git"

module Gitgit
  # Your code goes here...
  class CLI < Thor
    include Thor::Actions

    desc "init", "Initialise a git repo"
    def init
      return unless yes? "You're in the folder #{Dir.pwd}. Are you sure you want to make it into a git repository? (y/n)"
      Git.init
      say "Git repo created! Let's git going ...", :green
    end

    desc "save", "Save you changes to the repo"
    def save
      g = get_git_repo || return

      say "You're about to save the following changes:"
      say ""
      show_status(g)

      return unless yes? "Do you want to save these changes to git? (y/n)"
      m = ask "Give a short description of the work you're saving: "
      g.add(all:true)
      g.commit(m)
      say "Changes saved! :)", :green
    end

    desc "status", "See what changes you've made since you last save"
    def status
      g = get_git_repo || return
      say "The following changes have occurred since your last save:"
      show_status(g)
      say ""
      say "Type 'gitgit save' to save your work!"
      say ""
    end

    desc "lg", "Show your recent saves"
    def lg
      g = Git.open('.')
      g.log(20).each {|l| puts l }
    end

    desc "push", "Push your changes to github"
    def push
      g = get_git_repo || return

      if g.remotes.empty?
        say "Can't push as this repository has no remotes!", :red
        say ""
        say "You need to set up a repository on github and follow the instructions to connect it to this folder on your laptop."
        return
      end

      g.push
      say "Work successfully pushed to github!", :green

    rescue Git::GitExecuteError
      say "There was a problem pushing your work to github. :(", :red
    end

    desc "publish", "Publish your site to GitHub pages"
    def publish
       g = get_git_repo || return

      if g.remotes.empty?
        say "Can't push as this repository has no remotes!", :red
        say ""
        say "You need to set up a repository on github and follow the instructions to connect it to this folder on your laptop."
        return
      end

      g.push(g.remote('origin'), 'master:gh-pages', force: true)

      say "Site pushed to the gh-pages branch on github!", :green
    end

    desc "version", "Show which version of gitgit you're running"
    def version
      say "You're running gitgit version #{Gitgit::VERSION}!"
    end



    no_commands do
      def show_status(g)
        if g.ls_files.empty?
          new_files     = Dir.entries(".").select {|x| x[0] != "." }
          changed_files = []
          deleted_files = []
        else
          new_files     = g.status.added.merge(g.status.untracked)
          changed_files = g.status.changed
          deleted_files  = g.status.deleted
        end
        say ""
        say "New files:"
        new_files.each do |k, v|
          say "     #{k}", :green
        end
        say "     none" if new_files.empty?
        say ""
        say "Changed files:"
        changed_files.each do |k, v|
          say "     #{k}", :yellow
        end
        say "     none" if changed_files.empty?
        say ""
        say "Deleted files:"
        deleted_files.each do |k, v|
          say "     #{k}", :red
        end
        say "     none" if deleted_files.empty?
      end

      def get_git_repo
        Git.open('.')
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
        false
      end
    end

  end
end
