module ApplicationHelper

	def note_in_stars note
		note =  content_tag :div, class: 'note' do
			stars = []
			5.times{ stars << content_tag( :div, class: %w{star empty}) do; end}
			note.floor.times{ |n| stars[n] = content_tag( :div, class: %w{star full}, id: n) do; end }

			if note != note.floor
				stars[note.ceil] = content_tag( :div, class: %w{star half}) do; end 
			end
			raw stars.join
		end
		raw note
	end
end