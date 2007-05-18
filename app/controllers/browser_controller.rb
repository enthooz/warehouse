class BrowserController < ApplicationController
  before_filter :find_node

  def index
    render :action => @node.node_type.downcase
  end
  
  def text(raw = false)
    if @node.dir?
      render :layout => false, :content_type => Mime::TEXT
    else
      render :text => @node.content, :content_type => (!raw && @node.text? ? Mime::TEXT : @node.mime_type)
    end
  end

  def raw
    text(true)
  end

  protected
    def find_node
      @revision = params[:rev][1..-1].to_i if params[:rev]
      @node     = repository.node(params[:paths] * '/', @revision)
    end
end
