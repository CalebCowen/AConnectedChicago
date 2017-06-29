class Api::V1::NeighborhoodsController < Api::V1::ApiBaseController
  respond_to :json

  def show
    @hood = Neighborhood.find_by(name: params[:name])
    @events = Event.where(status: "approved").where("date >= ?", Date.today).order(:date, :time).where(neighborhood: @hood)
    @stories = Story.where(status: "approved").where(neighborhood: @hood)
    @artworks = Artwork.where(status: "approved").where(neighborhood: @hood)
  end

  def find_neighborhood
    hoods = Neighborhood.all
    @hood = hoods.find do |hood|
      hood.has?(params[:lat].to_f, params[:lng].to_f)
    end
    @events = Event.where(status: "approved").where("date >= ?", Date.today).order(:date, :time).where(neighborhood: @hood)
    @stories = Story.where(status: "approved").where(neighborhood: @hood)
    @artworks = Artwork.where(status: "approved").where(neighborhood: @hood)
  end
end
