class ContactsController < ApplicationController
    before_action :assign_contacts_variable, only: [:index]
    #before_action :authenticate_user!
  
    def index
      @contacts = @contacts.paginate(page: params[:page], per_page: 20)
    end

    def show
        @contact = Contact.find(params[:id])
    end

    def create
        @contact = Contact.new(contact_params)
      
        if @contact.save
          redirect_to @contact, notice: 'Contact was successfully created.'
        else
          render :new
        end
    rescue ActiveRecord::RecordInvalid => e
        flash.now[:alert] = e.message
        render :new
    end

    def new
        @contact = Contact.new
    end

    def update
        @contact = Contact.find(params[:id])
        if @contact.update(contact_params)
          redirect_to contacts_path, notice: 'Contact was successfully updated.'
        else
          render :edit
        end
    end

    def edit
        @contact = Contact.find(params[:id])
    end

    def versions
        @contact = Contact.find(params[:id])
        
        @versions = @contact.versions.map do |ver|
            {
                id: ver.id,
                event: ver.event,
                whodunnit: ver.whodunnit,
                created_at: ver.created_at.strftime('%F %r'),
                reified: ver.reify
            }
        end
    end

    def revert
        version = PaperTrail::Version.where(id: params[:id]).first
        #byebug
        if !version.nil?
          object = version.reify
    
          if object&.save
            redirect_to contacts_path, notice: 'Object was successfully reverted.'
          else
            redirect_to contacts_path, alert: 'Unable to revert object.'
          end
        else
          redirect_to contacts_path, alert: 'Unable to revert object.'
        end
        
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.message
      redirect_to contacts_path, alert: 'version not found.'
    end

    def destroy
      @contact = Contact.find(params[:id])
      
      if @contact.destroy
        redirect_to contacts_path, notice: 'Contact was successfully deleted.'
      else
        redirect_to contacts_path, alert: 'Failed to delete contact.'
      end

    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = e.message
      redirect_to contacts_path, alert: 'Failed to delete contact.'
    end
  
    private
  
    def assign_contacts_variable
      @contacts = Contact.all
    end

    def contact_params
        params.require(:contact).permit(:first_name, :last_name, :email, :phone_number)
    end
  end