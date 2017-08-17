def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Actor
  .select("movies.id, movies.title")
  .joins(:movies)
  .where("name in (?)", those_actors)
  .group("movies.id")
  .having("COUNT(*) = ?", those_actors.length)

end

def golden_age
  # Find the decade with the highest average movie score.
  Movie
       .select("yr/10 as decade")
       .group("yr/10")
       .order("Avg(score) DESC")
       .limit(1).first.decade * 10
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  subquery = Actor.select("movies.id")
                  .joins(:movies)
                  .where("actors.name = (?)", name)
  m = Movie
       .joins(:actors)
       .where(id: subquery).pluck("actors.name")
  m.delete(name)
  m

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor.joins("LEFT OUTER JOIN castings ON castings.actor_id = actors.id")
  .where("castings.actor_id IS NULL")
  .count
end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"

  search_string = "%"
  whazzername.downcase.chars.each do |char|
    search_string << char
    search_string << "%"
  end

  Movie.joins(:actors)
  .where("LOWER(name) LIKE (?)", search_string)
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor
  .joins(:movies)
  .select("actors.id, name, max(yr) - min(yr) career")
  .group(:id)
  .order("max(yr) - min(yr) DESC, name")
  .limit(3)
end
