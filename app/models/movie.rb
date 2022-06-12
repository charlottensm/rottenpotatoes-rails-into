class Movie < ActiveRecord::Base
  def self.all_ratings
    result = {}
    #model.select --> specific coloumn of database
  	self.select(:rating).uniq.each do |movie|
      #adds the uniq value of the movie.rating to the hash
  		result[movie.rating] = 1
  	end
  	return result
  end 

  def self.with_ratings(ratings)
    Movie.where(rating: ratings.keys)
  end
  
end
