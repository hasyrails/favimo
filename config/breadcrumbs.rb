crumb :root do
  link "ホーム", root_path
end

crumb :users do
  link "気になる人をタイプ", users_path
  parent :root
end

crumb :videos_search do
  link "YouTube動画を検索", youtube_videos_search_index_path
  parent :root
end

crumb :chat_rooms do
  link "チャットルーム", matching_index_path
  parent :root
end

crumb :chat_room do |user|
  chat_user_id = ChatRoom.find(params[:id]).chat_room_users.where.not(user_id: current_user.id).first.user_id
  user = User.find(chat_user_id)
  link "#{user.name}さん", chat_room_path
  parent :chat_rooms
end

crumb :shared_and_sharing_videos_with_chat_room_user do |user|
  link "#{user.name}さんと共有している動画", youtube_myvideos_status_like_shared_and_sharing_video_path
  parent :chat_room
end

crumb :user do |user|
  user = User.find(params[:user_id])
  if user == current_user
    link "プロフィール : #{user.name}さん", user_path(user)
  else
  link "#{user.name}さん", user_path(user)
  end
  parent :root
end

crumb :like_users do |user|
  user = User.find(params[:user_id])
  link "タイプした人をみる", user_status_like_index_path
  parent :user
end

crumb :share_video_select do |user|
  link "#{user.name}さんと動画を共有する", new_user_video_share_path
  parent :like_users
end

crumb :shared_and_sharing_history  do |user|
  link "共有している動画をみる", youtube_myvideos_status_like_shared_and_sharing_history_path(user)
  parent :user
end

crumb :edit_user do |user|
  link "情報を編集", edit_user_registration_path
  parent :user, user
end

crumb :search_result do
  link "気に入った動画をLike", youtube_myvideos_path
  parent :videos_search
end

crumb :dislike_myvideos do
  link "DisLikeした動画", youtube_myvideos_status_dislike_index_path
  parent :videos_search
end

crumb :like_myvideos do
  link "Likeした動画", youtube_myvideos_status_like_index_path
  parent :videos_search
end

crumb :sharing_myvideos do
  link "あなたが共有した動画", youtube_myvideos_status_like_sharing_videos_path
  parent :like_myvideos
end

crumb :shared_myvideos do
  link "あなたへ共有されている動画", youtube_myvideos_status_like_shared_videos_path
  parent :like_myvideos
end

crumb :sharing_myvideo_detail do |sharing_video|
  link "#{sharing_video.title.truncate(10)}", youtube_myvideos_status_like_sharing_videos_path
  parent :sharing_myvideos
end

crumb :common_video_like_users do
  link "動画をLikeした他のユーザー", users_video_common_like_path
  parent :like_myvideos
end

crumb :select_video_share_user do
  link "共有するユーザーを選ぶ", new_youtube_myvideos_status_like_share_path
  parent :like_myvideos
end

crumb :video_share_user_page do |user|
  link "共有する", new_youtube_myvideos_status_like_share_path
  parent :select_video_share_user, user
end
