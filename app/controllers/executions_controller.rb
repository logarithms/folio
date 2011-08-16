class ExecutionsController < ApplicationController
  # GET /executions
  # GET /executions.xml
  def index
    @executions = Execution.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @executions }
    end
  end

  # GET /executions/1
  # GET /executions/1.xml
  def show
    @execution = Execution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @execution }
    end
  end

  # GET /executions/new
  # GET /executions/new.xml
  def new
    @execution = Execution.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @execution }
    end
  end

  # GET /executions/1/edit
  def edit
    @execution = Execution.find(params[:id])
  end

  # POST /executions
  # POST /executions.xml
  def create
    @execution = Execution.new(params[:execution])

    respond_to do |format|
      if @execution.save
        format.html { redirect_to(@execution, :notice => 'Execution was successfully created.') }
        format.xml  { render :xml => @execution, :status => :created, :location => @execution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @execution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /executions/1
  # PUT /executions/1.xml
  def update
    @execution = Execution.find(params[:id])

    respond_to do |format|
      if @execution.update_attributes(params[:execution])
        format.html { redirect_to(@execution, :notice => 'Execution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @execution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /executions/1
  # DELETE /executions/1.xml
  def destroy
    @execution = Execution.find(params[:id])
    @execution.destroy

    respond_to do |format|
      format.html { redirect_to(executions_url) }
      format.xml  { head :ok }
    end
  end
end
