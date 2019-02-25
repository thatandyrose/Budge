json.all_categories Transaction::CATEGORIES.sort.uniq
json.categories @categories do |category|
  json.name category[:name]
  json.amount number_to_currency(category[:amount])
end
json.transactions @transactions do |t|
  json.id t.id
  json.date t.date.strftime("%a, %d %b, %Y")
  json.amount number_to_currency(t.amount)
  json.description t.description
  json.original_date t.original_date
  json.raw_description t.raw_description
  json.category t.category
  json.triggered_apply_to_similar t.triggered_apply_to_similar
end