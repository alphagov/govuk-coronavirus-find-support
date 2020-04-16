# frozen_string_literal: true

class CoronavirusForm::SessionController < ApplicationController
  def delete
    reset_session
    if params[:ext_r] == "true"
      redirect_to I18n.t("leave_this_website.link_redirect_to")
    else
      redirect_to "/"
    end
  end
end
