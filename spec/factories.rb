FactoryBot.define do
  factory :user do
    
  end

    factory :contact do
      first_name { "John" }
      last_name { "Doe" }
      email { "john.doe@example.com" }
      phone_number { "123-456-7890" }
    end
  
    #factory :version, class: PaperTrail::Version do
    #  item_type { "Contact" }
    #  item_id { association(:contact).id }
    #  event { "update" }
    #  whodunnit { nil }
    #  object_changes { "---\nid:\n- 1\n- 2\nfirst_name:\n- John\n- Jane\n" }
    #  created_at { Time.now }
    #end
  end