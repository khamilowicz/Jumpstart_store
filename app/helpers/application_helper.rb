module ApplicationHelper

	def note_in_stars note
		note =  content_tag :div, class: 'note' do
			stars = []
			5.times{ stars << content_tag( :i, class: %w{icon-star-empty}) do; end}
			note.ceil.times{ |n| stars[n] = content_tag( :i, class: %w{icon-star}, id: n) do; end }

			if note != note.floor
				stars[note.ceil] = content_tag( :i, class: %w{icon-plus}) do; end 
			end
			raw stars.join
		end
		raw note
	end
end