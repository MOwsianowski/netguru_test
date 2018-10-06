require "rails_helper"

describe Comment do
  it 'check first command' do
  	@user1 = create(:user)
	@movie1 = create(:movie)
    build(:comment, user_id: @user1.id, movie_id: @movie1.id).should be_valid
  end
end

describe Comment do
  it 'comment without user' do
	@movie1 = create(:movie)
    build(:comment, movie_id: @movie1.id, user_id: "").should be_invalid
  end
end

describe Comment do
  it 'comment without movie' do
  	@user1 = create(:user)
    build(:comment, user_id: @user1.id, movie_id: "").should be_invalid
  end
end

describe Comment do
  it 'check second commend of user - same movie' do
  	@user1 = create(:user)
	@movie1 = create(:movie)
	create(:comment, user_id: @user1.id, movie_id: @movie1.id)
    build(:comment, user_id: @user1.id, movie_id: @movie1.id).should be_invalid
  end
end

describe Comment do
  it 'check delete from other/not logged user' do
  	@user1 = create(:user)
	@movie1 = create(:movie)
	@comment1 = create(:comment, user_id: @user1.id, movie_id: @movie1.id)
	delete "/comments/#{Comment.last.id}"
    expect(Comment.last.id).to eq(@comment1.id)
  end
end