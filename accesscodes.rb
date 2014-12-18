module AccessCode
	@access_spaces =  [
		"Full and free access",
		"Open access",
		"Restricted (copyright)",
		"Restricted (location)",
		"Restricted (person)"
	]

	@access_questions =  [
		"Physical access restricted to NLNZ?",
		"In copyright?",
		"Permission required for reuse?",
		"Download restricted?",
		"Charge for download?",
		"Commercial use banned?"
	]

	@access_on =  [
		"Physical access for this item is restricted to National Library.",
		"This item is in copyright.",
		"Permission is required for the reuse of this item.",
		"You may not download a digital copy of this item.",
		"A high-quality copy of this item is available for pucrhase.",
		"You may not use this item for commercial purposes."
	]

	@access_off =  [
		"This item can be accessed from the Internet.",
		"There is no known copyright on this item.",
		"You have the blessing of the National Library to use this item as you see fit.",
		"Copies of this item is available are available for download.",
		"There is no charge to use this item.",
		"Commercial use is permitted."
	]


	def code_to_statement(code)
		statement = {
			:message => '',
			:details => []
		}
		code = code.to_s
		if not code =~ /\d\d\d/
			return {:error => "Not a valid access code."}
		end
		codes = code.split('')
		little_code = code[0].to_i
		big_code = code[1..2].join('').to_i
		if little_code > 4 or big_code > 63
			return {:error => "Not a valid access code."}
		end
		statement[:message] = @access_spaces[little_code]
		big_code.to_s(2).split('').each_with_index do |c, i|
			if c == "1"
				statement[:details][i] = {
					:outcome => true,
					:message => @access_on[i]
				}
			else
				statement[:details][i] = {
					:outcome => false,
					:message => @access_off[i]
				}
			end
		end
		statement
	end

end