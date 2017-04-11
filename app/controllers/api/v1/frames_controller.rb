class API::V1::FramesController < API::V1::APIController
  before_action :set_frame, only: [:show, :edit, :update, :destroy]

  # GET /frames
  # GET /frames.json
  def index
    @frames = Frame.all
  end

  # GET /frames/1
  # GET /frames/1.json
  def show
    respond_to do |format|
      format.json { render :show, location: api_v1_frame_url(@frame) }
    end
  end

  # GET /frames/new
  def new
    @frame = Frame.new
  end

  # GET /frames/1/edit
  def edit
  end

  # POST /frames
  # POST /frames.json
  def create
    @frame = Frame.new(frame_params)

    respond_to do |format|
      if @frame.save
        format.json { render :show, status: :created, location: api_v1_frame_url(@frame) }
      else
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frames/1
  # PATCH/PUT /frames/1.json
  def update
    respond_to do |format|
      if @frame.update(frame_params)
        format.json { render :show, status: :ok, location: api_v1_frame_url(@frame) }
      else
        format.json { render json: @frame.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frames/1
  # DELETE /frames/1.json
  def destroy
    @frame.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frame
      @frame = Frame.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def frame_params
      params.require(:frame).permit(:player_id, :number, :first_ball, :second_ball)
    end


end
