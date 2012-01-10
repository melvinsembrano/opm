require 'rho/rhocontroller'
require 'helpers/browser_helper'

class SetupController < Rho::RhoController
  include BrowserHelper

  # GET /Setup
  def index
    @setups = Setup.find(:all)
    render :back => '/app'
  end

  # GET /Setup/{1}
  def show
    @setup = Setup.find(@params['id'])
    if @setup
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Setup/new
  def new
    @setup = Setup.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Setup/{1}/edit
  def edit
    @setup = Setup.find(@params['id'])
    if @setup
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Setup/create
  def create
    @setup = Setup.create(@params['setup'])
    redirect :action => :index
  end

  # POST /Setup/{1}/update
  def update
    @setup = Setup.find(@params['id'])
    @setup.update_attributes(@params['setup']) if @setup
    redirect :action => :index
  end

  # POST /Setup/{1}/delete
  def delete
    @setup = Setup.find(@params['id'])
    @setup.destroy if @setup
    redirect :action => :index  
  end
end
