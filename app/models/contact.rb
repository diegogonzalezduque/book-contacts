class Contact < ApplicationRecord
    has_paper_trail ignore: [:created_at, :updated_at]

    validates :first_name, presence: true, length: { maximum: 50 }
    validates :last_name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :email, presence: true, uniqueness: true
    validates :phone_number, presence: true, length: { maximum: 20 }


    def to_yaml(options = {})
        YAML.dump(serializable_hash(only: [:first_name, :last_name, :email, :phone_number]), options)
    end
end
