
module NowPlaying
  module Utils
    module JsonpRenderer
      def json_p(response)
        render response, :jsonp
      end
      
      def render_jsonp(response)
        if params[:jsonp]
          out = params[:jsonp] + "(" + response.to_json + ")"
        else
          out = "(" + response.to_json + ")"
        end
        out
      end   
    end
  end
end
