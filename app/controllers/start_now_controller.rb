class StartNowController < ApplicationController
  def index
    redirect_to I18n.t("govwales_links.start_now_url")
  end
end
