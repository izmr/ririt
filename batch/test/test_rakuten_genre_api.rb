require '../model/rakuten_genre_api.rb'

$KCODE = 'UTF-8'
genre = RakutenGenreAPI::fetch 101311
p parent = genre.Body.GenreSearch.parent
p current = genre.Body.GenreSearch.current
p children = genre.Body.GenreSearch.child

children.each do |child|
  puts child.genreName
  p child.genreId
end
