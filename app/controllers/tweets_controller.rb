class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    render 'tweets/index'
  end

  def index_by_user
    @user = User.find_by(username: params[:username])

    if @user
      @tweets = @user.tweets
      render '/tweets/index'
    else
      render json: { success: false }
    end
  end

  def create
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      user = session.user
      @tweet = user.tweets.new(tweet_params)

      if @tweet.save
        render '/tweets/create'
      else
        render json: { success: false }
      end
    else
      render json: { success: false }
    end
  end

  def destroy
    @tweet = Tweet.find_by(id: params[:id])
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      if @tweet.destroy
        render json: { success: true }
      else
        render json: { success: false }
      end
    else
      render json: { success: false }
    end
  end

  private

    def tweet_params
      params.require(:tweet).permit(:user, :message)
    end
end
