module ApplicationHelper

	def note_in_stars note
		note = content_tag :div, class: 'note' do
			stars = []
			note.floor.times{|n|
				stars << content_tag( :div, class: %w{star full}, id: n) do; end
			}
			if note != note.floor
				stars << content_tag( :div, class: %w{star half}) do; end 
			end
			raw stars.join
		end
		raw note
	end
end
