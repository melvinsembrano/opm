require 'rho/rhoapplication'

class AppApplication < Rho::RhoApplication
  def initialize
    # Tab items are loaded left->right, @tabs[0] is leftmost tab in the tab-bar
    # Super must be called *after* settings @tabs!
    @tabs = nil
    #To remove default toolbar uncomment next line:
    # @@toolbar = nil
    @@toolbar = [
      {:action => "/app/Setup", :label => "Settings"}
    ]
    super

    # Uncomment to set sync notification callback to /app/Settings/sync_notify.
    # SyncEngine::set_objectnotify_url("/app/Settings/sync_notify")
    # SyncEngine.set_notification(-1, "/app/Settings/sync_notify", '')

    if System::get_property('platform') == 'Blackberry'
        set_geoview_notification url_for(:action => :geo_callback), "", 2
    else
        GeoLocation.set_notification url_for(:action => :geo_callback), "", 30
    end

  end
end
