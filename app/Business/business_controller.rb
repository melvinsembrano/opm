require 'rho/rhocontroller'
require 'helpers/browser_helper'

class BusinessController < Rho::RhoController
  include BrowserHelper

  # GET /Business
  def index
    if System::get_property('platform') == 'Blackberry'
        set_geoview_notification url_for(:action => :geo_callback), "", 2
    else
        GeoLocation.set_notification url_for(:action => :geo_callback), "", 30
    end

    render :back => '/app'
  end

  def geo_callback
    puts "geo_callback : #{@params}"

    if WebView.current_location !~ /GeoLocation/
        puts "Stopping geo location since we are away of geo page: " + WebView.current_location
        GeoLocation.turnoff
        return
    end
    
    if @params['known_position'].to_i != 0 && @params['status'] =='ok'
        if System::get_property('platform') == 'Blackberry'
            WebView.refresh
        else
            WebView.execute_js("updateLocation(#{@params['latitude']}, #{@params['longitude']})")
        end
    end
  end


  def find
    host = Setup.find(:first, :conditions => {:name => "host"})
    if host
      url = host.value
      auth = nil
    else
      url = Rho::RhoConfig.syncserver
      auth = {
        :type => :basic, 
        :username => "ourpatch", 
        :password => "ourpatch"
      } 
    end
    @category = @params['category']
    Rho::AsyncHttp.post(
      :url => "#{url}/patches/find.json",
      :authentication => auth,
      :body => "lat=#{GeoLocation.latitude.to_s}&lng=#{GeoLocation.longitude.to_s}&cat=#{@params['category']}",
      :callback => url_for(:action => :post_callback)
    )

    #@response["headers"]["Wait-Page"] = "true"
    render :action => :waiting
  end

  def result
    @results = Business.find(:all)
    render :action => :result
  end

  def post_callback
    if @params["status"] == "ok"
      @results = @params["body"]
      Business.delete_all
      @results.each do |p|
        Business.create(p)
      end
      WebView.navigate url_for :action => :result
    else
      WebView.navigate url_for :action => :index
    end
  end

  # GET /Business/{1}
  def show
    @business = Business.find(@params['id'])
    if @business
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Business/new
  def new
    @business = Business.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Business/{1}/edit
  def edit
    @business = Business.find(@params['id'])
    if @business
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Business/create
  def create
    @business = Business.create(@params['business'])
    redirect :action => :index
  end

  # POST /Business/{1}/update
  def update
    @business = Business.find(@params['id'])
    @business.update_attributes(@params['business']) if @business
    redirect :action => :index
  end

  # POST /Business/{1}/delete
  def delete
    @business = Business.find(@params['id'])
    @business.destroy if @business
    redirect :action => :index  
  end
end
