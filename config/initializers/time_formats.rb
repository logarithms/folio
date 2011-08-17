#Date::DATE_FORMATS[:default] = "%m/%d/%Y"
Time::DATE_FORMATS[:default] = "%m/%d/%Y %H:%M"
Date::DATE_FORMATS[:default] = lambda { |date| I18n.l(date) }  # pick "date" from en.yml
