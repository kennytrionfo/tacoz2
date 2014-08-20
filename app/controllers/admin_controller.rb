# parent controller. provides stuff to its children classes
class AdminController < ApplicationController
  before_action :authenticate_user!
end
