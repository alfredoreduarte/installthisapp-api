Dir[Rails.root.join('modules','*', 'models', '*.rb').to_s].each{|m| 
	load(m) unless m.include?("application.rb") or m.include?("setting.rb")
}