class Youtube::Myvideos::Status::Like::SharingVideosController < ApplicationController
  def index
    sharing_users = []
    sharing_videos = []

    keyword = params[:keyword]
    

    if keyword.present?
      
      sharing_user_ids = ShareVideo.where(from_user_id: current_user.id).pluck(:to_user_id)
    else
      sharing_video_ids = ShareVideo.where(from_user_id: current_user.id).map(&:youtube_video_id).uniq
      # 共有している動画レコードのYoutubeVideoテーブル上のidの配列 [1,3]

      sharing_video_ids.each do |sharing_video_id|
        sharing_video = YoutubeVideo.find(sharing_video_id)
        sharing_videos << sharing_video
      end
      @sharing_videos = sharing_videos

      sharing_video_ids.each do |sharing_video_id|
        sharing_users_each_sharing_video = ShareVideo.where(from_user_id: current_user.id, youtube_video_id: sharing_video_id).map(&:to_user)
        sharing_users << sharing_users_each_sharing_video.uniq
      end

      sharing_users.each do |sharing_users_each_by_sharing_video|
        while sharing_users_each_by_sharing_video.size > 3
          sharing_users_each_by_sharing_video.pop
        end
      end
      # 表示する共有ユーザーは３人とする
      
      # binding.pry

      @sharing_users = sharing_users
      # 各共有動画レコードごとの共有ユーザーを出力成功
      # @sharing_userは入れ子構造[[],[],...]

    end

    # binding.pry

    @sharing_videos = Kaminari.paginate_array(@sharing_videos).page(params[:page]).per(3)

  end
end
