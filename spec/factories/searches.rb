FactoryGirl.define do
  factory :search, class: KatSearch::Search do
    search 'suits s05e16'
    initialize_with { new(search) }
  end

  factory :search_failed, class: KatSearch::Search do
    search 'suits s05e72'
    initialize_with { new(search) }
  end
end
