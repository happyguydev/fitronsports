module Janitors
  class ConfirmationsController < Devise::ConfirmationsController
    def new
      super
    end
  end
end