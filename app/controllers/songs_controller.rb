class SongsController < ApplicationController
  include HTTParty
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  # This is where that Ransack magic happens!!
  def index
    # @songs = Song.all
    @q = Song.ransack(params[:q])
    @songs = @q.result(distinct: true)
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(artist: song_params[:artist],title: song_params[:title], recommender: song_params[:recommender], color: song_params[:color] )


    respond_to do |format|
      if @song.save
        p @song 
        format.html { redirect_to @song, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
        HTTParty.post("https://maker.ifttt.com/trigger/recommend_song/with/key/#{ENV["IFTT_KEY"]}",{ 
          :body => { "value1" => "#{@song.artist}", "value2" => "#{@song.title}", "value3" => "#{@song.recommender}" }.to_json,
          :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        })
        #   HTTParty.post("https://maker.ifttt.com/trigger/change_color/with/key/cyr9vRP_Ic-ezSabCIGWhX",{ 
        #   :body => { "value1" => "#{@song.color}" }.to_json,
        #   :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'}
        # })
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.fetch(:song, {})
    end
end
