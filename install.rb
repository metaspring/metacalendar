require 'fileutils'
FileUtils.mv("#{RAILS_ROOT}/vendor/plugins/metacalendar/lib/metacalendar.css",
             "#{RAILS_ROOT}/public/stylesheets/metacalendar.css")
