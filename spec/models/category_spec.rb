require 'rails_helper'

describe Category do 
	before(:each, :recent => true) do 
		@comedy = Category.create(name: 'comedy')
		@thriller = Category.create(name: 'thriller')
		@romcom = Category.create(name: 'romcom')
		@video1 = Video.create(title: 'kungfu', description: 'some description', created_at: 1.day.ago, category: @comedy)
		@video2 = Video.create(title: 'kungfu', description: 'some description', created_at: 2.day.ago, category: @comedy)
		@video3 = Video.create(title: 'kungfu', description: 'some description', created_at: 3.day.ago, category: @comedy)
		@video4 = Video.create(title: 'kungfu', description: 'some description', created_at: 4.day.ago, category: @comedy)
		@video5 = Video.create(title: 'kungfu', description: 'some description', created_at: 5.day.ago, category: @comedy)
		@video6 = Video.create(title: 'kungfu', description: 'some description', created_at: 6.day.ago, category: @comedy)
		@video7 = Video.create(title: 'kungfu', description: 'some description', created_at: 7.day.ago, category: @comedy)
		@videoA = Video.create(title: 'kungfu', description: 'some description', created_at: 1.day.ago, category: @thriller)
		@videoB = Video.create(title: 'kungfu', description: 'some description', created_at: 2.day.ago, category: @thriller)
	end 

	context 'test association' do 
		it { should have_many(:videos) }
	end 

	context 'test #recent_videos', :recent => true do 
		it 'should display the 6 most recent if it has more than 6 videos' do 
			expect(@comedy.recent_videos).to eq([@video1, @video2, @video3, @video4, @video5, @video6])
		end 

		it 'displays all videos if it has less than 6 videos' do 
			expect(@thriller.recent_videos).to eq([@videoA, @videoB])
		end 

		it 'returns an empty array if it has no videos' do 
			expect(@romcom.recent_videos).to eq([])
		end 
	end 
end 
