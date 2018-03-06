require_relative 'p05_hash_map'

def can_string_be_palindrome?(string)
  ch = string.split('')
  map = ch.map {|c| ch.count(c)}
  odd_count = 0
  map.each do |el|
    odd_count += 1 if el.odd?
    return false if odd_count > 1
  end
  true
end
