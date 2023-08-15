require 'rails_helper'

RSpec.describe Contact, type: :model do
  it "is valid with valid attributes" do
    contact = Contact.new(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      phone_number: "123-456-7890"
    )
    expect(contact).to be_valid
  end

  it "is not valid without a first name" do
    contact = Contact.new(last_name: 'er', phone_number: 333333, email: 'something@other.com')
    expect(contact).to_not be_valid
  end

  it "is not valid without an email" do
    contact = Contact.new(first_name: "whatever", last_name: 'something_else', phone_number: 222222)
    expect(contact).to_not be_valid
  end

  it "is not valid without an phone number" do
    contact = Contact.new(first_name: "whatever", last_name: 'something_else', email: 'something@else.com')
    expect(contact).to_not be_valid
  end

  it "is not valid without a valid email" do
    contact = Contact.new(first_name: "whatever", last_name: 'something_else', email: 'somethingelse.com', phone_number: 88888)
    expect(contact).to_not be_valid
  end

  it "is not valid without a last name" do
    contact = Contact.new(first_name: 'bet', phone_number: 333333, email: 'something@other.com')
    expect(contact).to_not be_valid
  end

  it "is valid without a last name" do
    contact = Contact.new(first_name: 'bet', last_name: 'er name', phone_number: 333333, email: 'something@other.com')
    expect(contact).to be_valid
  end

  it "is not valid without a last name" do
    contact = Contact.new()
    expect(contact).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    Contact.create(
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      phone_number: "123-456-7890"
    )
    duplicate_contact = Contact.new(
      first_name: "Jane",
      last_name: "Doe",
      email: "john.doe@example.com", # Duplicate email
      phone_number: "987-654-3210"
    )
    expect(duplicate_contact).to_not be_valid
  end

  it 'tracks changes for specific attributes', versioning: true do
    contact = Contact.create(first_name: 'John', last_name: 'Doe', email: 'fakeemail@nomail.com', phone_number: 4444444)
    contact.update(first_name: 'Jane')
    contact.update(last_name: 'Smith')
    versions = contact.versions
    
    expect(versions.count).to eq(3)
    expect(versions[0].event).to eq('create')
    expect(versions[1].event).to eq('update')
    expect(versions[2].event).to eq('update')

    reified_contact_1 = versions[1].reify
    reified_contact_2 = versions[2].reify

    changes_1 = reified_contact_1.changes
    changes_2 = reified_contact_2.changes

    expect(changes_1).to have_key('first_name')
    expect(changes_1['first_name']).to contain_exactly('John', 'Jane')

    expect(changes_2).to have_key('last_name')
    expect(changes_2['last_name']).to contain_exactly('Doe', 'Smith')
  end

  it 'tracks changes', versioning: true do
    contact = Contact.create(first_name: 'John', last_name: 'Doe', email: 'fakeemail@nomail.com', phone_number: 4444444)
    contact.update(first_name: 'Jane')
    versions = contact.versions
    expect(versions.count).to eq(2)  
    expect(versions.last.event).to eq('update')
  end
end