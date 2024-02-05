# health questions
HealthDec.create!(question: 'Do you smoke?', active: true, with_details: true, valid_answer: false)
HealthDecSubquestion.create!(health_dec_id: 1, question: 'How many sticks per day?')

puts 'Health questions created'
