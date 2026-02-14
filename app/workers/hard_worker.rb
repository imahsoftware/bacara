class HardWorker
  include Sidekiq::Worker

  def perform(procedimiento, *args)
		if args.any?
			cadena = "begin " + procedimiento + "("
		else
			cadena = "begin " + procedimiento
		end
		args.each do |x|
			if x.to_s == "null"
				cadena << x.to_s << ",";
			else
				cadena << "'"+x.to_s+"'" << ",";
			end
		end
		cadena = cadena.chomp(',')
		if args.any?
			cadena << "); end;"
		else
			cadena << "; end;"
		end
		ActiveRecord::Base.connection.execute("#{cadena}")
	end
end
