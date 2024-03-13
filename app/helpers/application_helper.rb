module ApplicationHelper
  def star_rating(rating)
    stars = ""
    rating.times { stars += '<i class="fa-solid fa-star"></i>'}
    (5 - rating).times { stars += '<i class="fa-regular fa-star"></i>' }
    stars.html_safe
  end


end
