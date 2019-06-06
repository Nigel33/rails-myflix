require 'rails_helper'

describe Video do 
	let(:family_guy) { Fabricate(:video, title: 'Family Guy', created_at: 1.day.ago) }  
	let(:happy_family) { Fabricate(:video, title: 'Happy Family', created_at:  2.day.ago) } 
		
	context 'test association' do 
		it { should belong_to(:category) }
	end 

	context 'test validation' do 
		it { should validate_presence_of(:title) }
		it { should validate_presence_of(:description) }
	end 

	context 'test ##search_by_title' do 
		it 'returns a few search results' do 
			expect(Video.search_by_title('family')).to include(family_guy, happy_family)
		end 

		it 'returns one search result' do 
			expect(Video.search_by_title('happy')).to include(happy_family)
		end

		it 'returns a partial match' do 
			expect(Video.search_by_title('ppy')).to include(happy_family)
		end  

		it 'returns search result with stripping leading and trailing whitespaces' do 
			expect(Video.search_by_title('   Happy   ')).to include(happy_family)
		end 

		it 'returns one search result case insensitive' do 
			expect(Video.search_by_title('HAPPY')).to include(happy_family)
		end 

		it 'returns search result sorted by updated_at' do 
			expect(Video.search_by_title('family')).to eq([family_guy, happy_family])
		end 

		it 'returns no search result' do 
			expect(Video.search_by_title('star')).to eq([])
		end 

		it 'returns no search results when input is blank' do
			expect(Video.search_by_title('  ')).to eq([])
		end 
	end 

	context "#rating" do 
		before do 
			@review1 = Fabricate(:review, rating: 3, video: family_guy)
			@review2 = Fabricate(:review, rating: 5, video: family_guy)
		end   
	
		it "should return an average rating of the reviews" do 
			

			expect(family_guy.rating).to eq(4.0)
		end 

		it "should return nil if there are no reviews" do 
			expect(happy_family.rating).to eq(nil)
		end 
	end 
end 