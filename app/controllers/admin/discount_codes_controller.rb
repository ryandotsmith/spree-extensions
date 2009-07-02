class Admin::DiscountCodesController < Admin::BaseController

  layout "admin"
  resource_controller
  create.after do
    @object.user = User.find( params[:user_id] )
    @object.save
  end
  create.wants.html { redirect_to collection_url }
  update.wants.html { redirect_to collection_url }

end
