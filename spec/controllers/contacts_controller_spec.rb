require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      contact = create(:contact)
      get :show, params: { id: contact.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect {
          post :create, params: { contact: attributes_for(:contact) }
        }.to change(Contact, :count).by(1)
      end

      it "redirects to the contact show page" do
        post :create, params: { contact: attributes_for(:contact) }
        expect(response).to redirect_to(Contact.last)
      end
    end

    context "with invalid attributes" do
      it "does not create a new contact" do
        expect {
          post :create, params: { contact: attributes_for(:contact, first_name: nil) }
        }.to_not change(Contact, :count)
      end

      it "renders the new template" do
        post :create, params: { contact: attributes_for(:contact, first_name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      contact = create(:contact)
      get :edit, params: { id: contact.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    let(:contact) { create(:contact) }

    context "with valid attributes" do
      it "updates the contact" do
        patch :update, params: { id: contact.id, contact: { first_name: "New Name" } }
        contact.reload
        expect(contact.first_name).to eq("New Name")
      end

      it "redirects to the contacts index page" do
        patch :update, params: { id: contact.id, contact: { first_name: "New Name" } }
        expect(response).to redirect_to(contacts_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the contact" do
        patch :update, params: { id: contact.id, contact: { first_name: nil } }
        contact.reload
        expect(contact.first_name).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, params: { id: contact.id, contact: { first_name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "GET #versions" do
    it "returns http success" do
      contact = create(:contact)
      get :versions, params: { id: contact.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #revert" do
    let(:contact) { create(:contact) }
    let!(:version) do
      version = PaperTrail::Version.create!(
        item_type: 'Contact',
        item_id: contact.id,
        event: 'update',
        whodunnit: nil,
        object: "---\nid: 1\nfirst_name: John\nlast_name: Doe\nemail: john.doe@example.com\nphone_number: 123-456-7890\n",
        created_at: Time.now
      )
      contact.update!(first_name: "Jane")
      version
    end

    context "with valid version id" do
      it "reverts the contact" do
        expect_any_instance_of(PaperTrail::Version).to receive(:reify).and_return(contact)
        expect(contact).to receive(:save).and_return(true)

        post :revert, params: { id: version.id }

        expect(response).to redirect_to(contacts_path)
        expect(flash[:notice]).to eq("Object was successfully reverted.")
      end
    end

    context "with invalid version id" do
      it "does not revert the contact" do
        post :revert, params: { id: 999 } 
        expect(response).to redirect_to(contacts_path)
        expect(flash[:alert]).to eq("Unable to revert object.")
      end
    end
  end

  describe "DELETE #destroy" do
    let(:contact) { create(:contact) } 
    before do
      contact
    end

    it "destroys the contact" do
      expect {
        delete :destroy, params: { id: contact.id }
      }.to change(Contact, :count).by(-1)
    end

    it "redirects to contacts#index after successful destroy" do
      delete :destroy, params: { id: contact.id }
      expect(response).to redirect_to(contacts_path)
    end

    it "redirects to contacts#index if contact cannot be destroyed" do
      allow_any_instance_of(Contact).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: contact.id }
      expect(response).to redirect_to(contacts_path)
      expect(flash[:alert]).to eq("Failed to delete contact.")
    end

    it "handles ActiveRecord::RecordNotFound exception" do
      expect {
        delete :destroy, params: { id: 999 } # Non-existing contact id
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end