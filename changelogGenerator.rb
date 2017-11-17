#!/usr/bin/ruby

# A script to automate changelog generation from Git commit messages
#
# For use with a git-flow workflow, it will take changes from the last tagged release
# where commit messages contain NEW, FIXED, and IMPROVED keywords and sort and fromat
# them into a Markdown release note list.
#
# The script takes version information from the macOS command agvtool and bases
# the product name on the first matching Xcode Info.plist found


# Constant CL_STRINGS: Strings for section titles and keywords
# :title is what is displayed in output
# :rx is the regex search to match each type, case sensitive
CL_STRINGS = {
  'new' => { :title => "Added", :rx => "(NEW|ADD(ED)?)" },
  'improved' => { :title => "Updated", :rx => "IMPROV(MENT|ED)?" },
  'fixed' => { :title => "Fixed", :rx => "FIX(ED)?" },
  'removed' => { :title => "Removed", :rx => "REMOVED" }
}

class String
  def cap_first
    self.sub(/^([a-z])(.*)$/) { $1.upcase << $2 }
  end

  def clean_entry
    rx = "(?:%s)" % CL_STRINGS.map{|k,v|
        v[:rx]
      }.join('|')
    return self.sub(/(- )?#{rx}:? */,'').cap_first
  end
end

class Change < Hash
  attr_accessor :githash, :date, :title, :changes
  def initialize(githash, date, title, changes)
    @githash = githash
    @date = date
    @title = title
    @changes = changes
    self
  end
end

class ChangeSet
  attr_accessor :new, :improved, :fixed, :removed

  def initialize
    @new = []
    @improved = []
    @fixed = []
    @removed = []
  end

  def add(type, change)
    case type
    when 'new'
      @new.push change
    when 'improved'
      @improved.push change
    when 'fixed'
      @fixed.push change
    when 'removed'
      @removed.push change
    end
  end

  def get(type)
    case type
    when 'new'
      return @new
    when 'improved'
      return @improved
    when 'fixed'
      return @fixed
    when 'removed'
      return @removed
    end
    return nil
  end
end

class ChangeLog < Array

  def initialize(change_array=[])
    return change_array
  end

  # returns array of :changes values
  def changes
    res = []
    self.each {|v|
      chgs = v.changes.strip.split(/\n/)
      chgs.delete_if {|e| e =~ /^\s*$/ }
      res = res.concat(chgs)
    }
    res
  end

  def changes!
    replace self.changes
  end
end

class ChangeLogger
  attr_reader :changes

  def initialize
    @changes = ChangeSet.new
    @log = gitlog
    sort_changes
  end

  def to_s
    output = ''
    res = {}
    CL_STRINGS.each {|k,v|
        res[k] = @changes.get(k)
    }
    res.each {|k,v|
      if (v.length > 0) 
        output += "#### #{CL_STRINGS[k][:title]}\n\n"
        output += "- #{v.join("\n- ")}\n\n"
      end
    }

    header + output
  end

  private

  def header
    parts = %x{agvtool mvers -terse}.match(/".*?\/([^\/]+?)\.plist"=(\d+\.\d+\.\d+)/)[1,2]
    header = "## #{parts[1].strip}"
    build = %x{agvtool vers -terse}.strip
    derp = header << %Q{ (#{build})}
    return derp.split(/\(/).first << "\n"
  end

  # returns ChangeLog
  def gitlog
    log = %x{git log \
      --pretty=format:'===%h%n%ci%n%s%n%b'\
      --since="$(git show -s --format=%ad $(git rev-list --tags --max-count=1))"}.strip

    if (log && log.length > 0)
      cl = ChangeLog.new
      log.split(/^===/).each {|entry|
        e = split_gitlog(entry.strip)
        cl.push(e) if e.githash
      }
      return cl
    end

    raise "Error reading log items"
  end

  def split_gitlog(entry)
    lines = entry.split(/\n/)
    loghash = lines.shift
    date = lines.shift
    title = lines.shift
    changes = lines.delete_if {|l| l.strip.empty? }.join("\n")
    return Change.new(loghash, date, title, changes)
  end

  def sort_changes
    rx = "(%s)" % CL_STRINGS.map {|k,v| v[:rx]}.join('|')
    chgs = []
    @log.changes.each {|l|
      chgs.concat(l.split("\n").delete_if {|ch| ch !~ /#{rx}/ })
    }
    chgs.each {|change|
      CL_STRINGS.each {|k,v|
        if change =~ /#{v[:rx]}/
          @changes.add(k, change.clean_entry)
        end
      }
    }
  end
end

cl = ChangeLogger.new
$stdout.puts cl.to_s