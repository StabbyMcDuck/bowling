class API::V1::PlayersController < API::V1::APIController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_game, only: [:index]

# GET /players/1
# GET /players/1.json
  def show
    respond_to do |format|
      format.json { render json: @player }
    end
  end

# GET /players
# GET /players.json
  def index
    @players = @game.players
  end

# POST /players
# POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.json { render json: @player, status: :created }
      else
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /players/1
# PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.json { render json: @player, status: :ok }
      else
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

# DELETE /players/1
# DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def player_params
    params.require(:player).permit(:game_id, :name)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

end

