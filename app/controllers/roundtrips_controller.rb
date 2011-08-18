class RoundtripsController < ApplicationController
  # GET /roundtrips
  # GET /roundtrips.xml
  def index
    @roundtrips = Roundtrip.all

    if params[:special] == "trade_exec"
      render "index_executions" and return
    end
 
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roundtrips }
    end
  end

  # GET /roundtrips/1
  # GET /roundtrips/1.xml
  def show
    @roundtrip = Roundtrip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @roundtrip }
    end
  end

  # GET /roundtrips/new
  # GET /roundtrips/new.xml
  def new
    @roundtrip = Roundtrip.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @roundtrip }
    end
  end

  # GET /roundtrips/1/edit
  def edit
    @roundtrip = Roundtrip.find(params[:id])
  end

  # POST /roundtrips
  # POST /roundtrips.xml
  def create
    @roundtrip = Roundtrip.new(params[:roundtrip])

    respond_to do |format|
      if @roundtrip.save
        format.html { redirect_to(@roundtrip, :notice => 'Roundtrip was successfully created.') }
        format.xml  { render :xml => @roundtrip, :status => :created, :location => @roundtrip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @roundtrip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roundtrips/1
  # PUT /roundtrips/1.xml
  def update
    @roundtrip = Roundtrip.find(params[:id])

    respond_to do |format|
      if @roundtrip.update_attributes(params[:roundtrip])
        format.html { redirect_to(@roundtrip, :notice => 'Roundtrip was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @roundtrip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roundtrips/1
  # DELETE /roundtrips/1.xml
  def destroy
    @roundtrip = Roundtrip.find(params[:id])
    @roundtrip.destroy

    respond_to do |format|
      format.html { redirect_to(roundtrips_url) }
      format.xml  { head :ok }
    end
  end
end
