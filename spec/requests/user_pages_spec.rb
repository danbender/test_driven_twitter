require 'spec_helper'

describe 'UserPages' do
  subject { page }

  describe 'signup page' do
    before(:each) { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title( full_title('Sign up')) }
  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_title(full_title(user.name)) }
    it { should have_content(user.name) }
  end

  describe 'signup' do
    before { visit signup_path }
    let(:submit) { 'Create my account' }

    describe 'with invalid information' do
      it 'should not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Name',                   with: 'dan'
        fill_in 'Email',                  with: 'dan@test.com'
        fill_in 'Password',               with: 'test12345'
        fill_in 'Password confirmation',  with: 'test12345'
      end
      it 'should create a user' do
        expect { click_button submit}.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'dan@test.com') }
        it { should have_content('dan') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome.') }
      end
    end

    describe 'when invalid signup information errors are prompted' do
      before { click_button submit }
      it { should have_content 'Sign up'}
      it { should have_content 'The form contains'}
      it { should have_content 'error'}
    end
  end
end