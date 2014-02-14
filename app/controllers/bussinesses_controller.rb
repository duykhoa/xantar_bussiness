class BussinessesController < ApplicationController
  before_action :set_bussiness, only: [:show, :edit, :update, :destroy]

  # GET /bussinesses
  # GET /bussinesses.json
  def index
    @bussinesses = Bussiness.all
  end

  # GET /bussinesses/1
  # GET /bussinesses/1.json
  def show
  end

  # GET /bussinesses/new
  def new
    @bussiness = Bussiness.new
  end

  # GET /bussinesses/1/edit
  def edit
  end

  # POST /bussinesses
  # POST /bussinesses.json
  def create
    @bussiness = Bussiness.new(bussiness_params)

    respond_to do |format|
      if @bussiness.save
        format.html { redirect_to @bussiness, notice: 'Bussiness was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bussiness }
      else
        format.html { render action: 'new' }
        format.json { render json: @bussiness.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bussinesses/1
  # PATCH/PUT /bussinesses/1.json
  def update
    respond_to do |format|
      if @bussiness.update(bussiness_params)
        format.html { redirect_to @bussiness, notice: 'Bussiness was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bussiness.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bussinesses/1
  # DELETE /bussinesses/1.json
  def destroy
    @bussiness.destroy
    respond_to do |format|
      format.html { redirect_to bussinesses_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bussiness
      @bussiness = Bussiness.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bussiness_params
      params[:bussiness]
    end
end
