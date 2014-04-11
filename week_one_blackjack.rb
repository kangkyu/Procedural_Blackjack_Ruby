# nice to meet you - get me_name
puts "Hello, before we start the game,"
puts "may I have your first name?"
$me_name = gets.chomp.capitalize
puts "Pleased to meet you, #{$me_name}."
# method: to ask to choose decks how many
def ask_num question
	puts question
	say = gets.chomp.to_i
	if (say >= 2 && say <= 4)
			say
	else
			ask_num "Supposed to say a number between 2 to 4.. how many?"
	end
end
num_deck = ask_num "We use multiple decks, please choose 2 to 4."
puts "We use #{num_deck} card sets. Let's start in a moment..."
# method: prepare that number of decks for the game
# cards are generated for example = [{:seven=>7}, "spade"], ...]
def set_gamedeck num_deck
	nums = { :ace => 11,
		:two => 2,
		:three => 3,
		:four => 4,
		:five => 5,
		:six => 6,
		:seven => 7,
		:eight => 8,
		:nine => 9,
		:ten => 10,
		:jack => 10,
		:queen => 10,
		:king => 10 }
	suits = ['spade', 'heart', 'diamond', 'club']
	deck_in_method = []
	(1..num_deck).each do
		suits.each do |suit|
			nums.each do |key, value|
				deck_in_method.push [{key => value}, suit]
			end
		end
	end
	deck_in_method
end
deck = (set_gamedeck num_deck).sort_by{rand}
$me_sum = $dealer_sum = 0
# method: status review
def status_review
	puts '=========================='
	# puts 'deck size'.ljust(12) + (' = ' + deck.size.to_s).rjust(3)
	puts 'me_points'.ljust(12) + (' = ' + $me_sum.to_s).rjust(3)
	puts 'dealer_pts'.ljust(12) + (' = ' + $dealer_sum.to_s).rjust(3)
	puts '=========================='
end
status_review
# method: deal_a_card
def deal_a_card curr_deck
	card = curr_deck.pop
	[card, curr_deck]
end
# deal two cards for each person at the beginning
# first two cards to me
puts "#{$me_name}, I will give you first two cards.."
2.times do
	# deal a card to me and count me_points
	after_deal = deal_a_card deck
	puts "Here you've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
	$me_sum = $me_sum + after_deal[0][0].values.join.to_i
end
# announce current me_points
puts "now for you it's #{$me_sum}."
# first two card to the dealer
puts "Two cards for me also.."
2.times do
	# self-deal a card and count dealer_points
	after_deal = deal_a_card deck 
	puts "I've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
	$dealer_sum = $dealer_sum + after_deal[0][0].values.join.to_i
end
# announce current dealer_points
puts "now for me it's #{$dealer_sum}."
status_review
# method: ask player to decide if hit
def ask_hit question
	puts question
	say = gets.chomp.downcase
	if (say == 'hit' || say == 'stay')
			say
	else
			ask_hit "#{$me_name}, you are supposed to say 'hit' or 'stay'"
	end
end
# rally starts
the_rally = true
busted = false
me_closed = dealer_closed = false
while the_rally
	# my turn - dealer asks, I decide if hit
	# one more card to me if I type 'hit'
	unless me_closed
		decision = ask_hit 'Your turn!'
		puts "Okay you said '#{decision}'"
		if decision == 'hit'
			# deal a card to me and count me_points
			after_deal = deal_a_card deck
			puts "Here you've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
			$me_sum = $me_sum + after_deal[0][0].values.join.to_i
			# when count points.. Aces can be interpreted as 1 
			if after_deal[0][0].values.join.to_i == 11
				$me_sum = $me_sum - 10 if $me_sum > 21
			end
			# announce current me_points
			puts "now for you it's #{$me_sum}."
		else # decision == 'stay'
			puts "Your final number is #{$me_sum}."
			me_closed = true
		end
		# game is over if anyone 'busted' (greater than 21) 
		# if one busted, the other one wins
		if $me_sum > 21
			puts "and you're busted. I won."
			puts "And I am BLACKJACK!" if $dealer_sum == 21
			break
		end
	end
	# dealer's turn - 'By rule, the dealer must hit 
	# until she has at least 17'
	unless dealer_closed
		puts 'My turn!'
		decision = if	$dealer_sum < 17 
			'hit'
		else
			'stay'
		end
		if decision == 'hit'
			puts "I say 'hit'"
			# self-deal a card and count dealer_points
			after_deal = deal_a_card deck 
			puts "I've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
			$dealer_sum = $dealer_sum + after_deal[0][0].values.join.to_i
			# when count points.. Aces can be interpreted as 1 
			if after_deal[0][0].values.join.to_i == 11
				$dealer_sum = $dealer_sum - 10 if $dealer_sum > 21
			end
			# announce current dealer_points
			puts "now for me it's #{$dealer_sum}."
		else # decision == 'stay'
			puts "I say 'stay', my final number is #{$dealer_sum}"
			dealer_closed = true
		end
		# game is over if anyone 'busted' (greater than 21) 
		# if one busted, the other one wins
		if $dealer_sum > 21
			puts "and I'm busted. You won."
			puts "And #{$me_name}, you're BLACKJACK! Lucky!" if $me_sum == 21
			break
		end
	end
	# game is over if both stay (both equal or less than 21) and,
	# in that case, compare number = same (draw) or more number (win)
	if (dealer_closed == true && me_closed == true)
		if $dealer_sum == $me_sum
			puts "We draw. another game?"
		elsif $dealer_sum > $me_sum
			puts "Your final number is lower, I won."
			puts "And I am BLACKJACK!" if $dealer_sum == 21
		else
			puts "Your final number is higher, You won."
			puts "And #{$me_name}, you're BLACKJACK! Lucky!" if $me_sum == 21
		end
		break
	end
	status_review
end
