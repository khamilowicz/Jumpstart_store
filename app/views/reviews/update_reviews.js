$('.reviews').html("<%= j render @product.reviews.order(:created_at), product: @product %>");
$('#review_title, #review_note, #review_body').val('');