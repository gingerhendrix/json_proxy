
module NowPlaying
  module Utils
    module JsonpRenderer
      def json_p(response)
        render response, :jsonp
      end
      
      def render_jsonp(response)
        response_text = response.to_json
        if params[:jsonp]
          out = params[:jsonp] + "(" + response_text + ")"
        else
          out = "(" + response_text + ")"
        end
        out
      end   
    end
  end
end
